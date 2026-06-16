import 'dart:async';
import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/domino_tile_widget.dart';
import '../widgets/glass_card.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> with SingleTickerProviderStateMixin {
  bool _isCameraMode = true; // True = Cámara, False = Calculadora Táctil
  bool _isScanning = false;
  bool _scanCompleted = false;
  int _scannerSum = 0;
  
  // Lista de fichas detectadas en el escaneo simulado
  final List<Map<String, int>> _detectedTiles = [];

  // Estado de fichas seleccionadas para la calculadora rápida (táctil)
  // Almacena un mapa de "top_bottom" -> bool indicando si está seleccionada
  final Map<String, bool> _selectedCalculatorTiles = {};

  // Lista de las 28 fichas del dominó doble 6 para la calculadora
  final List<Map<String, int>> _all28Tiles = [];

  late AnimationController _radarController;

  @override
  void initState() {
    super.initState();
    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Generar las 28 fichas de dominó
    for (int i = 6; i >= 0; i--) {
      for (int j = i; j >= 0; j--) {
        _all28Tiles.add({'top': i, 'bottom': j});
        _selectedCalculatorTiles['${i}_$j'] = false;
      }
    }
  }

  @override
  void dispose() {
    _radarController.dispose();
    super.dispose();
  }

  // Simula el escaneo con inteligencia artificial de la cámara
  void _simulateScan() {
    setState(() {
      _isScanning = true;
      _scanCompleted = false;
      _detectedTiles.clear();
      _scannerSum = 0;
    });

    _radarController.repeat();

    // Simular retraso de procesamiento de 2 segundos
    Timer(const Duration(milliseconds: 2200), () {
      if (!mounted) return;
      _radarController.stop();

      // Generar de 2 a 4 fichas aleatorias para contar
      final randomTiles = [
        {'top': 6, 'bottom': 5},
        {'top': 5, 'bottom': 4},
        {'top': 3, 'bottom': 2},
        {'top': 6, 'bottom': 6},
        {'top': 4, 'bottom': 0},
      ]..shuffle();

      final detectedCount = 2 + (DateTime.now().millisecond % 3); // 2, 3 o 4 fichas
      int sum = 0;
      
      setState(() {
        for (int i = 0; i < detectedCount; i++) {
          final tile = randomTiles[i];
          _detectedTiles.add(tile);
          sum += tile['top']! + tile['bottom']!;
        }
        _scannerSum = sum;
        _isScanning = false;
        _scanCompleted = true;
      });
    });
  }

  // Calcula el total en la calculadora visual táctil
  int _calculateTappingTotal() {
    int total = 0;
    _selectedCalculatorTiles.forEach((key, selected) {
      if (selected) {
        final parts = key.split('_');
        final top = int.parse(parts[0]);
        final bottom = int.parse(parts[1]);
        total += top + bottom;
      }
    });
    return total;
  }

  void _finishSelection(int points) {
    Navigator.pop(context, points);
  }

  Widget _buildCameraTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Visor de Cámara Simulada
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Fondo de Cámara simulando lente oscuro
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: DominoTheme.neonBlue.withOpacity(0.4), width: 2),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt,
                        size: 60,
                        color: Colors.white.withOpacity(0.15),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Apunta a las fichas restantes',
                        style: TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),

              // Marco de Enfoque / Scanner Target
              Container(
                width: 260,
                height: 180,
                decoration: BoxDecoration(
                  border: Border.all(color: DominoTheme.neonBlue, width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),

              // Animación de Radar al Escanear
              if (_isScanning)
                AnimatedBuilder(
                  animation: _radarController,
                  builder: (context, child) {
                    return Positioned(
                      top: 100 + (_radarController.value * 150),
                      child: Container(
                        width: 250,
                        height: 3,
                        decoration: BoxDecoration(
                          color: DominoTheme.neonBlue,
                          boxShadow: [
                            BoxShadow(
                              color: DominoTheme.neonBlue.withOpacity(0.8),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

              // Pantalla de carga al procesar
              if (_isScanning)
                Container(
                  color: Colors.black54,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(color: DominoTheme.neonBlue),
                        const SizedBox(height: 16),
                        Text(
                          'Detectando fichas con IA...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Sección de Resultados
        if (_scanCompleted) ...[
          const SizedBox(height: 12),
          GlassCard(
            borderColor: DominoTheme.neonGreen.withOpacity(0.4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Fichas Detectadas',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: DominoTheme.neonGreen),
                    ),
                    Text(
                      'Total: $_scannerSum Puntos',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 95,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _detectedTiles.length,
                    itemBuilder: (context, index) {
                      final tile = _detectedTiles[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: DominoTileWidget(
                          top: tile['top']!,
                          bottom: tile['bottom']!,
                          size: 45,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 16),
        // Botón de Escaneo
        if (!_isScanning)
          CustomButton(
            text: _scanCompleted ? 'Escanear de Nuevo' : 'Tomar Foto y Escanear',
            gradientColors: const [DominoTheme.neonBlue, Color(0xFF0D47A1)],
            icon: Icons.camera,
            onPressed: _simulateScan,
          ),
        const SizedBox(height: 12),
        if (_scanCompleted)
          CustomButton(
            text: 'Agregar $_scannerSum Puntos',
            gradientColors: const [DominoTheme.neonGreen, Color(0xFF1B5E20)],
            onPressed: () => _finishSelection(_scannerSum),
          ),
      ],
    );
  }

  Widget _buildCalculatorTab() {
    final int currentTotal = _calculateTappingTotal();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Toca las fichas restantes para sumarlas:',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ),
        // Grid de fichas
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 12,
              childAspectRatio: 0.58,
            ),
            itemCount: _all28Tiles.length,
            itemBuilder: (context, index) {
              final tile = _all28Tiles[index];
              final key = '${tile['top']}_${tile['bottom']}';
              final isSelected = _selectedCalculatorTiles[key] ?? false;

              return DominoTileWidget(
                top: tile['top']!,
                bottom: tile['bottom']!,
                size: 30,
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    _selectedCalculatorTiles[key] = !isSelected;
                  });
                },
              );
            },
          ),
        ),

        // Footer de sumatoria
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: DominoTheme.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Calculado', style: TextStyle(color: DominoTheme.textMuted, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(
                    '$currentTotal Puntos',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: DominoTheme.gold),
                  ),
                ],
              ),
              SizedBox(
                width: 140,
                child: CustomButton(
                  text: 'Agregar Puntos',
                  height: 44,
                  gradientColors: const [DominoTheme.gold, Color(0xFFF57C00)],
                  onPressed: () => _finishSelection(currentTotal),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Puntos', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          children: [
            // Selector de Modo (Cámara vs Calculadora)
            Container(
              height: 46,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: DominoTheme.cardColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() {
                        _isCameraMode = true;
                      }),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _isCameraMode ? DominoTheme.neonBlue.withOpacity(0.2) : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: _isCameraMode ? Border.all(color: DominoTheme.neonBlue.withOpacity(0.5)) : null,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt, color: _isCameraMode ? Colors.white : DominoTheme.textMuted, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              'Escanear Fichas',
                              style: TextStyle(
                                color: _isCameraMode ? Colors.white : DominoTheme.textMuted,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() {
                        _isCameraMode = false;
                      }),
                      child: Container(
                        decoration: BoxDecoration(
                          color: !_isCameraMode ? DominoTheme.gold.withOpacity(0.2) : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: !_isCameraMode ? Border.all(color: DominoTheme.gold.withOpacity(0.5)) : null,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.grid_on, color: !_isCameraMode ? Colors.white : DominoTheme.textMuted, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              'Calculadora Rápida',
                              style: TextStyle(
                                color: !_isCameraMode ? Colors.white : DominoTheme.textMuted,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _isCameraMode ? _buildCameraTab() : _buildCalculatorTab(),
            ),
          ],
        ),
      ),
    );
  }
}

// Extensión temporal para facilitar CustomButton con ancho definido
extension on CustomButton {
  // Ajuste para soportar anchos específicos
  Widget get widthWidget => Container();
}
