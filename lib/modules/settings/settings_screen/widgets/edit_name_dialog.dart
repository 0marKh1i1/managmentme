import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditNameDialog extends StatefulWidget {
  const EditNameDialog({super.key, required this.initialName, required this.onSave});

  final String initialName;
  final Future<void> Function(String newName) onSave;

  @override
  State<EditNameDialog> createState() => _EditNameDialogState();
}

class _EditNameDialogState extends State<EditNameDialog> {
  late final TextEditingController _nameController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (_isSaving) return;

    setState(() => _isSaving = true);
    try {
      await widget.onSave(_nameController.text);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text('edit_name'.tr),
      content: TextField(
        controller: _nameController,
        decoration: InputDecoration(
          hintText: 'enter_your_name'.tr,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        autofocus: true,
        textCapitalization: TextCapitalization.words,
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: Text('cancel'.tr)),
        ElevatedButton(
          onPressed: _isSaving ? null : _handleSave,
          child: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text('save'.tr),
        ),
      ],
    );
  }
}
