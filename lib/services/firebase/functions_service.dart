import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';

class FunctionsService {
  final _functions = FirebaseFunctions.instance;

  Future<String> generateIdea(String topic) async {
    try {
      final callable = _functions.httpsCallable('generateIdea');
      final result = await callable.call({'topic': topic});

      final text = result.data['result']?.toString() ?? 'Sin respuesta';

      final chunks = RegExp('.{1,1000}', dotAll: true).allMatches(text);
      for (final c in chunks) {
        debugPrint('🟢 Resultado chunk: ${c.group(0)}');
      }

      return text;
    } catch (e) {
      debugPrint('❌ Error Firebase: $e');
      throw Exception('Error llamando a la función: $e');
    }
  }
}
