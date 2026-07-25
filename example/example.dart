import 'package:sublist3r_engine/sublist3r_engine.dart';

void main() async {
  final engine = Sublist3rEngine();
  await engine.initialize();
  print('Sublist3rEngine is ready for tactical operations.');
}
