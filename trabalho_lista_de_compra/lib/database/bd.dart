import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
// Função para deletar o banco de dados
// Future<void> deleteAppDatabase() async {
//   try {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, 'lista_de_compras_mobile.db');

//     await deleteDatabase(path);

//     print('Banco de dados deletado com sucesso.');
//   } catch (e) {
//     print('Erro ao deletar o banco de dados: $e');
//   }
// }

// Função para inicializar o banco de dados
Future<Database> ListaDatabase() async {
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
            preco_total REAL DEFAULT 0,
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
    version: 2,
  );
}
    
// Funções para manipulação de dados na tabela Usuarios
Future<void> inserirUsuario(Database db, Map<String, dynamic> usuario) async {
  try {
    await db.insert(
      'Usuarios',
      usuario,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  } catch (e) {
    print('Erro ao inserir usuário: $e');
  }
}

Future<void> atualizarUsuario(Database db, int id, Map<String, dynamic> novosDados) async {
  try {
    await db.update(
      'Usuarios',
      novosDados,
      where: 'id_usu = ?',
      whereArgs: [id],
    );
  } catch (e) {
    print('Erro ao atualizar usuário: $e');
  }
}

Future<void> deletarUsuario(Database db, int id) async {
  try {
    await db.delete(
      'Usuarios',
      where: 'id_usu = ?',
      whereArgs: [id],
    );
  } catch (e) {
    print('Erro ao deletar usuário: $e');
  }
}

// Funções para manipulação de dados na tabela Listas
Future<void> inserirLista(Database db, Map<String, dynamic> lista) async {
  try {
    await db.insert(
      'Listas',
      lista,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  } catch (e) {
    print('Erro ao inserir lista: $e');
  }
}

Future<void> atualizarLista(Database db, int id, Map<String, dynamic> novosDados) async {
  try {
    await db.update(
      'Listas',
      novosDados,
      where: 'id_lista = ?',
      whereArgs: [id],
    );
  } catch (e) {
    print('Erro ao atualizar lista: $e');
  }
}

Future<void> deletarLista(Database db, int id) async {
  try {
    await db.delete(
      'Listas',
      where: 'id_lista = ?',
      whereArgs: [id],
    );
  } catch (e) {
    print('Erro ao deletar lista: $e');
  }
}

// Funções para manipulação de dados na tabela Itens
Future<void> inserirItem(Database db, Map<String, dynamic> item) async {
  try {
    await db.insert(
      'Itens',
      item,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  } catch (e) {
    print('Erro ao inserir item: $e');
  }
}

Future<void> atualizarItem(Database db, int id, Map<String, dynamic> novosDados) async {
  try {
    await db.update(
      'Itens',
      novosDados,
      where: 'id_item = ?',
      whereArgs: [id],
    );
  } catch (e) {
    print('Erro ao atualizar item: $e');
  }
}

Future<void> deletarItem(Database db, int id) async {
  try {
    await db.delete(
      'Itens',
      where: 'id_item = ?',
      whereArgs: [id],
    );
  } catch (e) {
    print('Erro ao deletar item: $e');
  }
}

// Funções para manipulação de dados na tabela ListaItens
Future<void> inserirListaItem(Database db, Map<String, dynamic> listaItem) async {
  try {
    await db.insert(
      'ListaItens',
      listaItem,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  } catch (e) {
    print('Erro ao inserir lista item: $e');
  }
}

Future<void> atualizarListaItem(Database db, int id, Map<String, dynamic> novosDados) async {
  try {
    await db.update(
      'ListaItens',
      novosDados,
      where: 'id_lista_item = ?',
      whereArgs: [id],
    );
  } catch (e) {
    print('Erro ao atualizar lista item: $e');
  }
}

Future<void> deletarListaItem(Database db, int id) async {
  try {
    await db.delete(
      'ListaItens',
      where: 'id_lista_item = ?',
      whereArgs: [id],
    );
  } catch (e) {
    print('Erro ao deletar lista item: $e');
  }
}
