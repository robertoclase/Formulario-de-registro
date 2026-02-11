import 'package:flutter/material.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../core/constants/app_constants.dart';
import '../services/counter_service.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  final _counterService = CounterService();

  @override
  Widget build(BuildContext context) {
    final counter = _counterService.counter;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contador'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _counterService.reset();
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.largePadding),
                child: Column(
                  children: [
                    Icon(
                      Icons.add_circle,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: AppConstants.defaultPadding),
                    Text(
                      'Contador',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: AppConstants.smallPadding),
                    Text(
                      'Has presionado el botón esta cantidad de veces:',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppConstants.largePadding),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.largePadding,
                        vertical: AppConstants.defaultPadding,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '${counter.value}',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    const SizedBox(height: AppConstants.defaultPadding),
                    Text(
                      'Incremento: ${counter.step}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    Text(
                      'Actualizado: ${_formatTime(counter.lastUpdated)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: AppConstants.largePadding),
            
            // Controles
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _counterService.decrement();
                      });
                    },
                    icon: const Icon(Icons.remove),
                    label: const Text('Decrementar'),
                  ),
                ),
                const SizedBox(width: AppConstants.defaultPadding),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _counterService.increment();
                      });
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Incrementar'),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppConstants.defaultPadding),
            
            PrimaryButton(
              text: 'Cambiar incremento',
              icon: Icons.settings,
              onPressed: () => _showStepDialog(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showStepDialog() async {
    final controller = TextEditingController(
      text: _counterService.counter.step.toString(),
    );

    final result = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cambiar incremento'),
        content: TextFormField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Nuevo incremento',
            prefixIcon: Icon(Icons.settings),
          ),
          keyboardType: TextInputType.number,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              final value = int.tryParse(controller.text);
              if (value != null && value > 0) {
                Navigator.pop(context, value);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (result != null) {
      setState(() {
        _counterService.setStep(result);
      });
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'hace ${difference.inSeconds}s';
    } else if (difference.inHours < 1) {
      return 'hace ${difference.inMinutes}m';
    } else {
      return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }
}