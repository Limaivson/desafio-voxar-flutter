// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:folder/comunication.dart';

class Folder extends StatelessWidget {
  const Folder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animals prediction',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FolderSelectionScreen(),
    );
  }
}

class FolderSelectionScreen extends StatefulWidget {
  const FolderSelectionScreen({Key? key}) : super(key: key);

  @override
  _FolderSelectionScreenState createState() => _FolderSelectionScreenState();
}

class _FolderSelectionScreenState extends State<FolderSelectionScreen> {
  String _selectedFolderPath = '';
  bool _isLoading = false;
  bool _isSuccess = false;
  bool _isError = false;

  Future<void> _selectFolder() async {
    setState(() {
      _isLoading = true; // Ativar indicador de progresso
    });

    final String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      var status = await sendPath(selectedDirectory);
      if (status == 1) {
        setState(() {
          _selectedFolderPath = selectedDirectory;
          _isLoading = false; // Desativar indicador de progresso
          _isSuccess = true; // Indicar sucesso
          _isError = false; // Desativar indicador de erro
          _showDialog('Success', 'Folder path sent successfully. The csv file is now available');
        });
      } else {
        setState(() {
          _isLoading = false; // Desativar indicador de progresso
          _isSuccess = false; // Desativar indicador de sucesso
          _isError = true; // Indicar erro
        });
        _showDialog('Error', 'Failed to send folder path. Please try again.');
      }
    } else {
      setState(() {
        _isLoading = false; // Desativar indicador de progresso
        _isSuccess = false; // Desativar indicador de sucesso
        _isError = true; // Indicar erro
      });
      _showDialog('Error', 'No folder selected. Please try again.');
    }
  }

  void _showDialog(String title, String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animals prediction'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _isLoading ? null : _selectFolder,
              child: const Text('Select folder'),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator() // Indicador de progresso
                : _isSuccess
                    ? const Icon(Icons.check_circle, color: Colors.green, size: 48) // Ícone de finalizado
                    : _isError
                        ? const Icon(Icons.error, color: Colors.red, size: 48) // Ícone de erro
                    : const SizedBox(), // Espaço reservado para o ícone de finalizado
            const SizedBox(height: 10),
            const Text(
              'Selected folder:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _selectedFolderPath.isNotEmpty ? _selectedFolderPath : 'No folders selected',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
