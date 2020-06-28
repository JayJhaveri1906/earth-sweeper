import 'package:earthsweeper/models/game.dart';
import 'package:flutter/material.dart';

import '../controllers/mine_block_controller.dart';


enum SweeperControl{
  left, up, right, down
}

class MineSweeperProvider extends ChangeNotifier{
  final Game game;
  int _counter;

  List<List<MineBlockController>> points;

  String get currentMoodAsset => "assets/happy.jpeg"; // TODO: Implement win lose logic

  int get counter => _counter;
  set counter(i){
    counter = i;
    game.duration = _counter;
    notifyListeners();
  }

  MineSweeperProvider(this.game){
    // Set initial timer
    _counter = game.duration;
  }

  Future<List<List<MineBlockController>>> buildMineBlockProviders(){
    points = [];

    // Build MineBlockProviders
    for(int x = 0; x < game.width; x++){
      points.add([]);
      for(int y = 0; y < game.height; y++){
        points[x].add(MineBlockController(game.points[x][y]));
      }
    }
  }

  void blockClick(MineBlockController mineBlock){
    // Check clicked point if its mined than finish game
    // If its nearest point greater than 0 only show him
    // If its nearest point equals to 0 than search all nearest fields

    if(mineBlock.pointData.mined){
      // TODO: Implement game finish
    }
    else if (mineBlock.pointData.nearbyCount > 0){
      mineBlock.opened = true;
    }
    else if (mineBlock.pointData.nearbyCount == 0){
      // Apply walk method to open all nonmined block
      openBlock(mineBlock.pointData.x, mineBlock.pointData.y, allowPassThoughNumber: true);
    }
  }

  // Opens block, returns false if block is mined, and not opens it
  bool openBlock(int x, int y, {bool allowPassThoughNumber = false}){
    if((x >= 0 && x < game.width) && (y >= 0 && y < game.height) && !points[x][y].pointData.mined && !points[x][y].flagged && !points[x][y].opened){
      MineBlockController point = points[x][y];

      if((allowPassThoughNumber && point.pointData.nearbyCount > 0) || point.pointData.nearbyCount == 0){
        point.opened = true;

        // open all neiberhood blocks
        openBlock(x - 1, y, allowPassThoughNumber: point.pointData.nearbyCount == 0); // West
        openBlock(x - 1, y - 1, allowPassThoughNumber: point.pointData.nearbyCount == 0); // North West
        openBlock(x, y - 1, allowPassThoughNumber: point.pointData.nearbyCount == 0); // North
        openBlock(x + 1, y - 1, allowPassThoughNumber: point.pointData.nearbyCount == 0); // North East
        openBlock(x + 1, y, allowPassThoughNumber: point.pointData.nearbyCount == 0); // East
        openBlock(x + 1, y + 1, allowPassThoughNumber: point.pointData.nearbyCount == 0); // South East
        openBlock(x, y + 1, allowPassThoughNumber: point.pointData.nearbyCount == 0); // South
        openBlock(x - 1, y + 1, allowPassThoughNumber: point.pointData.nearbyCount == 0); // South West
      }
    }
  }
}