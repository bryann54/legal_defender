import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'attorneys_event.dart';
part 'attorneys_state.dart';

class AttorneysBloc extends Bloc<AttorneysEvent, AttorneysState> {
  AttorneysBloc() : super(AttorneysInitial()) {
    on<AttorneysEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
