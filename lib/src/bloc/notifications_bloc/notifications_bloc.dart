import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meta/meta.dart';

import '../../repository/data_repository.dart';

part 'notifications_event.dart';

part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final DataRepository _dataRepository;

  NotificationsBloc(this._dataRepository) : super(NotificationsInitial()) {
    on<ListenToTokenStarted>(_onListenToTokenStarted);
    on<ListenToForGroundMessageStarted>(_onListenToForGroundMessageStarted);
    on<ListenToForMessageOpeningAppStarted>(
        _onListenToMessageOpeningAppStarted);
  }

  void checkNotificationType(Map<String, dynamic> data) async {
    /*
    if (data['type'] == 'product') {
      final productsCubit = getItInstance<ProductsCubit>();
      ProductModel? product = await productsCubit.getProductData(data['id']);
      if (product != null)
        routerUtils.pushNamedRoot(context, Routes.productDetailsScreen,
            arguments: product);
      // Navigator.pushNamed(context, Routes.productDetailsScreen,
      //     arguments: product);
    } else if (data['type'] == 'banner') {
      final bannersCubit = getItInstance<BannersCubit>();
      BannerModel? banner = await bannersCubit.getBannerData(data['id']);
      if (banner != null)
        routerUtils.pushNamedRoot(context, Routes.productsScreen,
            arguments: banner);
      // Navigator.pushNamed(context, Routes.productsScreen, arguments: banner);
    } else if (data['type'] == 'order') {
      routerUtils.pushNamedRoot(context, Routes.orderDetailsScreen,
          arguments: data['id']);
      // Navigator.pushNamed(context, Routes.orderDetailsScreen,
      //     arguments: data['id']);
    }
    */
  }

  void setUpNotifications() {
    // if (notificationProvider.initialMessage != null) {
    //   checkNotificationType(notificationProvider.initialMessage.data);
    // }
  }

  _onListenToMessageOpeningAppStarted(ListenToForMessageOpeningAppStarted event,
      Emitter<NotificationsState> emit) {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      print("From MessageOpeningApp ${message.data}");
      if (notification != null && android != null) {
        // print("From message opening app ${message.data}");
        // checkNotificationType(message.data);
      }
    });
  }

  _onListenToForGroundMessageStarted(
      ListenToForGroundMessageStarted event, Emitter<NotificationsState> emit) {
    try {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        print('from ForGroundMessage data is ${message.data}');
        // print('onMessage notification is ${message.notification}');
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        if (notification != null && android != null) {}
      });
    } catch (e) {}
  }

  _onListenToTokenStarted(
      ListenToTokenStarted event, Emitter<NotificationsState> emit) async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      print("token is $token");
      if (token != null) await _dataRepository.updateUserData({"token": token});

      FirebaseMessaging.instance.onTokenRefresh.listen((tokenStream) async {
        await _dataRepository.updateUserData({"token": tokenStream});
        // emit(TokenUpdated());
      });
    } catch (e) {
      print(e.toString());
      emit(TokenError(e.toString()));
    }
  }
}
