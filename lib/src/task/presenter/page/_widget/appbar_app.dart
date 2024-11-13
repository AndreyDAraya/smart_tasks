part of '../page.dart';

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({
    required GlobalKey<State<StatefulWidget>> titleKey,
    required GlobalKey<State<StatefulWidget>> tabBarKey,
    required TabController tabController,
  })  : _titleKey = titleKey,
        _tabBarKey = tabBarKey,
        _tabController = tabController;

  final GlobalKey<State<StatefulWidget>> _titleKey;
  final GlobalKey<State<StatefulWidget>> _tabBarKey;
  final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Color(0xFFE8EAF6),
            ],
          ),
        ),
      ),
      title: Text(
        'Smart Task',
        key: _titleKey,
        style: const TextStyle(
          color: _kPrimaryColor,
          fontSize: 28,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: Container(
          key: _tabBarKey,
          child: TabBar(
            controller: _tabController,
            labelColor: _kPrimaryColor,
            unselectedLabelColor: Colors.grey.shade400,
            indicatorColor: _kAccentColor,
            indicatorWeight: 5,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
            tabs: const [
              Tab(text: 'Open'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(48 * 2);
}
