import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/order.dart';
import './provider/provider_products.dart';
import './screens/product_overview_screen.dart';
import './provider/cart.dart';
import './screens/cart_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/order_screen.dart';
import './screens/user_product_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './provider/auth.dart';
import './screens/splashScreen.dart';
import './helpers/custom_route.dart';

void main()=> runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context)=> Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProviderProducts>(
          create: null,
          update: (context, auth, previousProducts)=> ProviderProducts(auth.token, auth.userId, previousProducts== null ? [] : previousProducts.items),
        ),
        ChangeNotifierProxyProvider<Auth, Order>(
          create: null,
          update: (context, auth, previousOrders)=> Order(auth.token, auth.userId, previousOrders== null ? [] : previousOrders.orders),
        ),
        ChangeNotifierProvider(
          create: (context)=> Cart(),
        ),
      ],

      child: Consumer<Auth>(
        builder: (context, auth, _)=> MaterialApp(
          title: "Shopping App",
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.brown,
            accentColor: Colors.white,
            textTheme: TextTheme(
              headline6: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.2,
                fontFamily: "Anton",
              ),
            ),

            pageTransitionsTheme: PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: CustomPageTransitionBuilder(),
                  TargetPlatform.iOS: CustomPageTransitionBuilder(),
                }
            ),

            appBarTheme: AppBarTheme(
              textTheme: TextTheme(
                headline6: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.2,
                  fontFamily: "Lato",
                ),
              ),
            ),
          ),

          home: auth.isAuth ? ProductOverviewScreen() : FutureBuilder(
            future: auth.tryAutoLogin(),
            builder: (context, authResultSnapshot)=> authResultSnapshot.connectionState== ConnectionState.waiting
                ? SplashScreen()
                : AuthScreen(),
          ),

          routes: {
            "/cart-screen": (context)=> CartScreen(),
            "/product-detail": (context)=> ProductDetail(),
            "/order-screen": (context)=> OrderScreen(),
            "/user-product": (context)=> UserProductScreen(),
            "/edit-product": (context)=> EditProductScreen(),
          },
        ),
      ),
    );
  }
}
