import 'dart:async';

import 'package:counter_async/counter_async_page/bloc/counter_async_bloc.dart';
import 'package:counter_async/counter_async_page/bloc/counter_async_state.dart';
import 'package:counter_async/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_page/flutter_bloc_page.dart';

class CounterAsyncPage extends StatelessWidget {
  const CounterAsyncPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CounterAsyncCubit(
          const PageBlocState(uiState: CounterAsyncStateUiState(isLoading: false, counter: 1))),
      child: Builder(
        builder: (context) {
          final bloc = BlocProvider.of<CounterAsyncCubit>(context);
          return PageBlocConsumer<CounterAsyncCubit, CounterAsyncStateUiEvent,
                  CounterAsyncStateUiState>(
              uiEventListener: (context, uiEvent) async {
                _handleUiEvent(context, uiEvent);
              },
              uiBuilder: (context, uiState) => Column(
                    children: [
                      const SizedBox(height: 40),
                      Text("Counter: ${uiState.counter}"),
                      TextButton(
                          onPressed: uiState.isLoading
                              ? null
                              : () async {
                                  await bloc.click();
                                },
                          child: const Text("Click me!")),
                      TextButton(
                          onPressed: () {
                            mainNavKey.currentState!.push(MaterialPageRoute(
                              settings: const RouteSettings(name: "another_page"),
                              builder: (context) => const CounterAsyncPage(),
                            ));
                          },
                          child: const Text("Open another page")),
                    ],
                  ));
        },
      ),
    );
  }

  Future<void> _handleUiEvent(BuildContext context, CounterAsyncStateUiEvent uiEvent) async {
    switch (uiEvent) {
      case ShowAlertDialog():
        return showAdaptiveDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(uiEvent.title),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text(uiEvent.message),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ));
    }
  }
}
