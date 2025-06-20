import 'package:flutter/material.dart';

class SideBarWidget extends StatelessWidget {
  final String userName;
  final bool isExpanded;
  final VoidCallback onToggle;

  const SideBarWidget({
    super.key,
    required this.userName,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isExpanded ? 220 : 60,
      height: MediaQuery.of(context).size.height - 70,
      padding: const EdgeInsets.only(top: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            offset: Offset(4, 0),
            color: Color.fromRGBO(0, 0, 0, 0.1),
          ),
        ],
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(isExpanded ? Icons.chevron_left : Icons.menu),
              onPressed: onToggle,
            ),
          ),
          if (userName.isNotEmpty)
            Column(
              children: [
                const Icon(Icons.account_circle,
                    size: 40, color: Colors.black54),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: isExpanded ? 1.0 : 0.0,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      userName,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              children: [
                _buildItem(Icons.home, "Inicio",
                    route: "/init", context: context),
                _buildItem(Icons.settings, "Configuración"),
                _buildItem(Icons.eco, "Ver mis plantas"),
                _buildItem(Icons.memory, "Ver mis dispositivos",
                    route: "/see-my-devices", context: context),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildItem(IconData icon, String label,
      {String? route, BuildContext? context}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: Icon(icon, size: 24, color: Colors.black87),
      title: isExpanded
          ? Text(label, style: const TextStyle(fontWeight: FontWeight.w600))
          : null,
      onTap: () {
        if (route != null && context != null) {
          Navigator.pushNamed(context, route);
        }
      },
      hoverColor: const Color.fromRGBO(106, 170, 41, 0.1),
    );
  }
}
