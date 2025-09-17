import '../../../Interface/entityInterface.dart';
import 'TransformerAbstract.dart';

abstract class TransformerCombinator<T extends EntityInterface> implements TransformerAbstract<T> {
  final List<TransformerAbstract<T>> transformers;
  TransformerCombinator(this.transformers);
}

