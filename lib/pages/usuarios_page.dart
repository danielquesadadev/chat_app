import 'package:flutter/material.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:chat_app/models/usuarios.dart';

class UsuariosPage extends StatefulWidget {
  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final usuarios = [
    Usuario(uid: '1', nombre: 'Daniel', email: 'test1@gmail.com', online: true),
    Usuario(uid: '2', nombre: 'Pedro', email: 'test2@gmail.com', online: true),
    Usuario(uid: '3', nombre: 'Eva', email: 'test3@gmail.com', online: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'Mi usuario',
          style: TextStyle(color: Colors.black54),
        ),
        leading: IconButton(
          icon: Icon(Icons.exit_to_app, color: Colors.black54),
          onPressed: () {},
        ),
        actions: [
          Container(
              margin: EdgeInsets.only(right: 10),
              child: /* Icon(
                Icons.check_circle_rounded,
                color: Colors.blue[400],
              ) */
                  Icon(
                Icons.offline_bolt,
                color: Colors.red,
              )),
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        child: _litsViewUsuarios(),
        enablePullDown: true,
        onRefresh: _cargarUsuarios,
        header: WaterDropHeader(
          complete: Icon(
            Icons.check,
            color: Colors.blue[400],
          ),
          waterDropColor: Colors.blue,
        ),
      ),
    );
  }

  ListView _litsViewUsuarios() {
    return ListView.separated(
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, i) {
          return _usuarioListTile(usuarios[i]);
        },
        separatorBuilder: (_, i) => Divider(),
        itemCount: usuarios.length);
  }

  ListTile _usuarioListTile(Usuario usuario) {
    return ListTile(
      title: Text(usuario.nombre),
      subtitle: Text(usuario.email),
      leading: CircleAvatar(
        child: Text(
          usuario.nombre.substring(0, 2),
        ),
        backgroundColor: Colors.blue[100],
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: usuario.online ? Colors.green[400] : Colors.red),
      ),
    );
  }

  _cargarUsuarios() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }
}
