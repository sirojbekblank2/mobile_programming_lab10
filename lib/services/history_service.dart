
import '../models/classification_record.dart';

class HistoryService {
  final List<ClassificationRecord> _records = [];

  List<ClassificationRecord> get records =>
      List.unmodifiable(_records);

  void add(ClassificationRecord record) {
    _records.insert(0, record);
  }

  void clear() {
    _records.clear();
  }
}
