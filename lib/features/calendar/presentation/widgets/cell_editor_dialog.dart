import 'package:flutter/material.dart';

/// Widget para editar el contenido de una celda
class CellEditorDialog extends StatefulWidget {
  final String? initialContent;
  final Function(String) onSave;

  const CellEditorDialog({
    super.key,
    this.initialContent,
    required this.onSave,
  });

  @override
  State<CellEditorDialog> createState() => _CellEditorDialogState();
}

class _CellEditorDialogState extends State<CellEditorDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialContent ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar Evento'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          hintText: 'Ej: Parcial, Prueba P, Conjunta',
          border: OutlineInputBorder(),
        ),
        maxLines: 2,
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        if (widget.initialContent != null && widget.initialContent!.isNotEmpty)
          TextButton(
            onPressed: () {
              widget.onSave('');
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ElevatedButton(
          onPressed: () {
            widget.onSave(_controller.text.trim());
            Navigator.of(context).pop();
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
