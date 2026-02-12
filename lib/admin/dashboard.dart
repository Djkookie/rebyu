import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:get/get.dart';
import 'package:rebyu/admin/controllers/admin_controller.dart';
import 'package:rebyu/admin/details.dart';
import 'package:rebyu/admin/items.dart';
import 'package:rebyu/admin/settings.dart';


String description(String description) {
  String desString = 'N/A';

  if(description.isNotEmpty) {
    if(description.length >= 5) {
      desString = description.replaceRange((description.length >= 100) ? 100 :description.length, description.length, '...');
    }
  }
  return desString;
}


class WebContentWrapper extends StatefulWidget {

  const WebContentWrapper({super.key});

  @override
  State<WebContentWrapper> createState() => _WebContentWrapperState();
}

class _WebContentWrapperState extends State<WebContentWrapper> with TickerProviderStateMixin {

  ValueNotifier<bool?> showGridView = ValueNotifier<bool?>(false);

  final menuTitles = ['Redirects','Pages'];

  final AdminController settings = Get.find();

  int? selected = 0;

  void selectCard(int? index) {
    setState(() {
      selected = index;
    });
  }

  int _navigationIndex = 0;

  @override
  Widget build(BuildContext context) {

    const List<NavigationDestination> destinations = <NavigationDestination>[
      NavigationDestination(
        label: 'Redirect Links',
        icon: Icon(Icons.list_alt),
      ),
      NavigationDestination(
        label: 'Pages',
        icon: Icon(Icons.edit_attributes),
      ),
    ];

    showGridView.value = Breakpoints.mediumAndUp.isActive(context);

    return Obx(() => Scaffold(
      backgroundColor: Colors.blue[100],
      body: Theme(
        data: ThemeData().copyWith(
          navigationRailTheme: const NavigationRailThemeData(
            indicatorColor: Colors.deepOrange,
            selectedIconTheme: IconThemeData(
              color: Colors.white
            )
          ),
          elevatedButtonTheme:  ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: const WidgetStatePropertyAll(Colors.deepOrange),
              // foregroundColor: WidgetStatePropertyAll(Colors.white),
              textStyle: const WidgetStatePropertyAll(TextStyle(
                color: Colors.white
              )),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: const BorderSide(
                        color: Colors.deepOrange
                    )
                ),
              ),
            )
          ),
          tabBarTheme: const TabBarTheme(
            labelColor: Colors.deepOrange,
            indicatorColor: Colors.deepOrange,
          ),
          menuBarTheme: const MenuBarThemeData(
            style: MenuStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.deepOrange)
            )
          ),
          buttonTheme: const ButtonThemeData(
            buttonColor: Colors.deepOrange,
          ),
          textButtonTheme: const TextButtonThemeData(
            style: ButtonStyle(
              iconColor: WidgetStatePropertyAll(Colors.deepOrange),
              // foregroundColor: WidgetStatePropertyAll(Colors.white),
              textStyle: WidgetStatePropertyAll(TextStyle(
                color: Colors.white
              ))
            )
          ),

        ),
        child: AdaptiveLayout(
          topNavigation: SlotLayout(
            config: <Breakpoint, SlotLayoutConfig?>{
              Breakpoints.standard: SlotLayout.from(
                key: const Key('header'),

                builder: (_) => Container(
                  height: 50,
                  width: double.infinity,
                  color: Colors.blue[800],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        // child: Image.asset(
                        //   'lib/assets/images/ttss_title.png'
                        // ),

                        child: TextButton.icon(
                          onPressed: () {
                            Get.offAllNamed('/sites');
                          },
                          icon: const Icon(Icons.settings, color: Colors.black),
                          label: Text(
                            settings.currentSite.toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black
                            )
                          ),
                        )

                      ),
                      const Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 10.0),
                        child:  Text(
                          'Admin',
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ),
            },
          ),
          primaryNavigation: SlotLayout(
            config: <Breakpoint, SlotLayoutConfig?>{
              Breakpoints.medium: SlotLayout.from(
                inAnimation: AdaptiveScaffold.leftOutIn,
                key: const Key('primaryNavigation'),
                builder: (_) {
                  return AdaptiveScaffold.standardNavigationRail(

                    onDestinationSelected: (int index) {
                      setState(() {
                        _navigationIndex = index;
                      });
                    },
                    selectedIndex: _navigationIndex,
                    leading: ScaleTransition(
                      scale: AnimationController(vsync: this, duration: const Duration(milliseconds: 100)),
                      child: Column(children:[
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 18),
                          child: const Icon(Icons.menu),
                        ),

                      ])
                    ),
                    padding: const EdgeInsets.all(0),
                    backgroundColor: Colors.black,
                    unSelectedLabelTextStyle: const TextStyle(color: Colors.white),
                    unselectedIconTheme: const IconThemeData(color: Colors.white),
                    selectedLabelTextStyle: const TextStyle(color: Colors.deepPurpleAccent),
                    destinations: <NavigationRailDestination>[
                      slideInNavigationItem(
                        begin: -1,
                        controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 100)),
                        // controller: _itemsListController,
                        icon: Icons.book,
                        label: 'Redirect Links',

                      ),
                      slideInNavigationItem(
                        begin: -2,
                        controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 120)),
                        // controller: _settingsController,
                        icon: Icons.person,
                        label: 'Settings',
                      ),
                    ],
                  );
                },
              ),
              Breakpoints.largeAndUp: SlotLayout.from(
                key: const Key('Large primaryNavigation'),
                builder: (_) => AdaptiveScaffold.standardNavigationRail(
                  backgroundColor: Colors.white,
                  unSelectedLabelTextStyle: const TextStyle(color: Colors.black),
                  selectedLabelTextStyle: const TextStyle(color: Colors.black),
                  unselectedIconTheme: const IconThemeData(color: Colors.black),
                  padding: const EdgeInsets.only(right: 10),
                  onDestinationSelected: (int index) {
                    setState(() {
                      _navigationIndex = index;
                    });
                  },
                  selectedIndex: _navigationIndex,
                  extended: true,
                  trailing: Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: double.maxFinite,
                          height: 50,
                          color: Colors.grey.shade300,
                          child: TextButton.icon(
                            style: const ButtonStyle(
                              overlayColor:WidgetStatePropertyAll(Colors.transparent)
                            ),
                            onPressed: () {
                              settings.userLogout();
                              Get.offAllNamed('/mylogin');
                            },
                            icon: const Icon(Icons.logout),
                            label: const Text('Logout', style: TextStyle(color: Colors.black))
                          )
                        )
                      ],
                    )

                  ),
                  destinations: destinations.map((NavigationDestination destination) {
                    return AdaptiveScaffold.toRailDestination(destination);
                  }).toList(),
                ),
              ),
            },
          ),

          body: SlotLayout(
            config: <Breakpoint, SlotLayoutConfig?>{
              Breakpoints.standard: SlotLayout.from(
                inAnimation: AdaptiveScaffold.bottomToTop,
                key: const Key('body'),
                builder: (_) =>  (_navigationIndex == 0 ) ?  Container(
                  margin: const EdgeInsets.only(right: 10, top: 10),
                  child: SocialItemsLinks(
                    items: settings.socialData,
                    selected: selected,
                    selectedCard: selectCard,
                  )
                ) : const SettingsPage()
              )
            },
          ),
          secondaryBody: (_navigationIndex == 0 && settings.socialData.isNotEmpty)
              ? SlotLayout(
                  config: <Breakpoint, SlotLayoutConfig?>{
                    Breakpoints.mediumAndUp: SlotLayout.from(
                      outAnimation: AdaptiveScaffold.stayOnScreen,
                      key: const Key('Secondary Body'),
                      builder: (_) => SafeArea(
                        child: ItemDetailsPage(item: settings.socialData[selected ?? 0])
                      )
                    ),
                  },
                )
              : null,
          bottomNavigation: SlotLayout( 
            config: <Breakpoint, SlotLayoutConfig?>{
              Breakpoints.small: SlotLayout.from(
                key: const Key('bottomNavigation'),
                outAnimation: AdaptiveScaffold.topToBottom,
                builder: (_) => AdaptiveScaffold.standardBottomNavigationBar(
                  destinations: destinations,
                ),
              )
            },
          ),
          bodyRatio: (_navigationIndex == 0) ? 0.8 : 0.3,
        ),
      )
    ));

  }

  NavigationRailDestination slideInNavigationItem({
    required double begin,
    required AnimationController controller,
    required IconData icon,
    required String label,
  }) {
    return NavigationRailDestination(
      icon: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(begin, 0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: controller, curve: Curves.easeInOutCubic),
        ),
        child: Icon(icon),
      ),
      label: Text(label),
    );
  }


}