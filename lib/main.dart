import 'package:flutter/material.dart';

void main() {
  runApp(TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TicTacToeScreen(),
    );
  }
}

class TicTacToeScreen extends StatefulWidget {
  @override
  _TicTacToeScreenState createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  List<List<String>> _board = List.generate(3, (_) => List.generate(3, (_) => ''));
  bool _isXTurn = true;
  String _winner = '';
  List<String> _previousWinners = [];

  void _resetGame() {
    setState(() {
      if (_winner.isNotEmpty && _winner != 'Draw') {
        _previousWinners.add(_winner);
      }
      _board = List.generate(3, (_) => List.generate(3, (_) => ''));
      _isXTurn = true;
      _winner = '';
    });
  }

  void _makeMove(int row, int col) {
    if (_board[row][col] == '' && _winner == '') {
      setState(() {
        _board[row][col] = _isXTurn ? 'X' : 'O';
        _isXTurn = !_isXTurn;
        _winner = _checkWinner();
      });
    }
  }

  String _checkWinner() {
    for (int i = 0; i < 3; i++) {
      if (_board[i][0] != '' && _board[i][0] == _board[i][1] && _board[i][1] == _board[i][2]) {
        return _board[i][0];
      }
      if (_board[0][i] != '' && _board[0][i] == _board[1][i] && _board[1][i] == _board[2][i]) {
        return _board[0][i];
      }
    }
    if (_board[0][0] != '' && _board[0][0] == _board[1][1] && _board[1][1] == _board[2][2]) {
      return _board[0][0];
    }
    if (_board[0][2] != '' && _board[0][2] == _board[1][1] && _board[1][1] == _board[2][0]) {
      return _board[0][2];
    }
    if (_board.every((row) => row.every((cell) => cell != ''))) {
      return 'Draw';
    }
    return '';
  }

  Widget _buildCell(int row, int col) {
    return GestureDetector(
      onTap: () => _makeMove(row, col),
      child: Container(
        decoration: BoxDecoration(
          color: _board[row][col] == 'X' ? Colors.lightBlue[100] : Colors.pink[100],
          border: Border.all(color: Colors.black),
        ),
        child: Center(
          child: Text(
            _board[row][col],
            style: TextStyle(
              fontSize: 40.0,
              fontWeight: FontWeight.bold,
              color: _board[row][col] == 'X' ? Colors.blue : Colors.red,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWinnerList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _previousWinners.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            'Winner: ${_previousWinners[index]}',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2.0),
                ),
                child: GridView.builder(
                  padding: EdgeInsets.all(8.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    int row = index ~/ 3;
                    int col = index % 3;
                    return _buildCell(row, col);
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              _winner.isEmpty
                  ? 'Turn: ${_isXTurn ? 'X' : 'O'}'
                  : _winner == 'Draw'
                  ? 'It\'s a Draw!'
                  : 'Winner: $_winner',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetGame,
              child: Text('Reset Game'),
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 16.0),
                textStyle: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Text(
                      'Previous Winners',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: _buildWinnerList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
