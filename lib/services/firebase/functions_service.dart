import 'package:cloud_functions/cloud_functions.dart';

class FunctionsService {
  final _functions = FirebaseFunctions.instance;

  Future<String> generateIdea(String topic) async {
    try {
      final callable = _functions.httpsCallable('generateIdea');
      final result = await callable.call({'topic': topic});

      final text = result.data['result']?.toString() ?? 'Sin respuesta';

      // 🔍 Divide el texto en trozos de 1000 caracteres para evitar truncamiento en consola
      final chunks = RegExp('.{1,1000}', dotAll: true).allMatches(text);
      for (final c in chunks) {
        print('🟢 Resultado chunk: ${c.group(0)}');
      }

      return text;
    } catch (e) {
      print('❌ Error Firebase: $e');
      throw Exception('Error llamando a la función: $e');
    }
  }
}
