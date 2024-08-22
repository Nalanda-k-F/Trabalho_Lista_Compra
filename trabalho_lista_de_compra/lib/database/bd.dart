import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> initDatabase() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'lista_de_compras_mobile.db');

  return openDatabase(
    path,
    onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE Usuarios (
            id_usu INTEGER PRIMARY KEY AUTOINCREMENT,
            nome_usu TEXT NOT NULL,
            email_usu TEXT UNIQUE,
            senha_usu TEXT NOT NULL,
            confirmacao_senha_usu TEXT
        );
      ''');
      await db.execute('''
        CREATE TABLE Listas (
            id_lista INTEGER PRIMARY KEY AUTOINCREMENT,
            nome_lista TEXT,
            data_criacao_lista TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            id_usu_fk INTEGER,
            concluida_lista INTEGER DEFAULT 0,
            valor_total_lista REAL,
            status_lista TEXT DEFAULT 'Em Andamento', 
            FOREIGN KEY (id_usu_fk) REFERENCES Usuarios(id_usu)
        );
      ''');
      await db.execute('''
        CREATE TABLE UnidadesMedida (
            id_unidade_medida INTEGER PRIMARY KEY AUTOINCREMENT,
            nome_unidade TEXT NOT NULL
        );
      ''');
      await db.execute('''
        CREATE TABLE Itens (
            id_item INTEGER PRIMARY KEY AUTOINCREMENT,
            nome_item TEXT NOT NULL,
            quantidade_item REAL NOT NULL,
            id_unidade_medida_fk INTEGER,
            FOREIGN KEY (id_unidade_medida_fk) REFERENCES UnidadesMedida(id_unidade_medida)
        );
      ''');
      await db.execute('''
        CREATE TABLE ListaItens (
            id_lista_item INTEGER PRIMARY KEY AUTOINCREMENT,
            quantidade_lista_item INTEGER,
            comprado_lista_item INTEGER DEFAULT 0,
            preco_unitario_lista_item REAL,
            id_lista_fk INTEGER,
            id_item_fk INTEGER,
            FOREIGN KEY (id_lista_fk) REFERENCES Listas(id_lista),
            FOREIGN KEY (id_item_fk) REFERENCES Itens(id_item)
        );
      ''');

      // Inserindo dados iniciais na tabela UnidadesMedida
      await db.insert('UnidadesMedida', {'nome_unidade': 'Kg'});
      await db.insert('UnidadesMedida', {'nome_unidade': 'Litro'});
      await db.insert('UnidadesMedida', {'nome_unidade': 'Unidade'});
    },
    version: 1,
  );
}

// Função para inserir dados na tabela Usuarios
Future<void> inserirUsuario(Database db, Map<String, dynamic> usuario) async {
  await db.insert(
    'Usuarios',
    usuario,
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

// Função para atualizar dados na tabela Usuarios
Future<void> atualizarUsuario(Database db, int id, Map<String, dynamic> novosDados) async {
  await db.update(
    'Usuarios',
    novosDados,
    where: 'id_usu = ?',
    whereArgs: [id],
  );
}

// Função para deletar dados na tabela Usuarios
Future<void> deletarUsuario(Database db, int id) async {
  await db.delete(
    'Usuarios',
    where: 'id_usu = ?',
    whereArgs: [id],
  );
}

// Função para inserir dados na tabela Listas
Future<void> inserirLista(Database db, Map<String, dynamic> lista) async {
  await db.insert(
    'Listas',
    lista,
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

// Função para atualizar dados na tabela Listas
Future<void> atualizarLista(Database db, int id, Map<String, dynamic> novosDados) async {
  await db.update(
    'Listas',
    novosDados,
    where: 'id_lista = ?',
    whereArgs: [id],
  );
}

// Função para deletar dados na tabela Listas
Future<void> deletarLista(Database db, int id) async {
  await db.delete(
    'Listas',
    where: 'id_lista = ?',
    whereArgs: [id],
  );
}

// Função para inserir dados na tabela Itens
Future<void> inserirItem(Database db, Map<String, dynamic> item) async {
  await db.insert(
    'Itens',
    item,
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

// Função para atualizar dados na tabela Itens
Future<void> atualizarItem(Database db, int id, Map<String, dynamic> novosDados) async {
  await db.update(
    'Itens',
    novosDados,
    where: 'id_item = ?',
    whereArgs: [id],
  );
}

// Função para deletar dados na tabela Itens
Future<void> deletarItem(Database db, int id) async {
  await db.delete(
    'Itens',
    where: 'id_item = ?',
    whereArgs: [id],
  );
}

// Função para inserir dados na tabela ListaItens
Future<void> inserirListaItem(Database db, Map<String, dynamic> listaItem) async {
  await db.insert(
    'ListaItens',
    listaItem,
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

// Função para atualizar dados na tabela ListaItens
Future<void> atualizarListaItem(Database db, int id, Map<String, dynamic> novosDados) async {
  await db.update(
    'ListaItens',
    novosDados,
    where: 'id_lista_item = ?',
    whereArgs: [id],
  );
}

// Função para deletar dados na tabela ListaItens
Future<void> deletarListaItem(Database db, int id) async {
  await db.delete(
    'ListaItens',
    where: 'id_lista_item = ?',
    whereArgs: [id],
  );
}
