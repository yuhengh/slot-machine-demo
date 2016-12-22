package
{
    import flash.geom.Rectangle;

    import starling.core.Starling;

    import starling.display.Button;
    import starling.display.Image;

    import starling.display.Sprite;
    import starling.display.Stage;
    import starling.events.Event;
    import starling.text.TextField;
    import starling.textures.RenderTexture;

    public class HUD extends Sprite
    {
        public static const ADD_BALANCE_AMOUNT:int = 50;
        public static const ADD_BET_AMOUNT:int = 1;

        public static const CARD_SIZE:int = 150;
        public static const SPIN_SPEED:int = 3000;

        private var _slotMachine:SlotMachine;

        private var _balance:int;
        private var _bet:int;
        private var _line:int;

        private var _prevPositions:Array;

        private var _spinning:Boolean = false;

        public var _root:Sprite;

        public var _topContainer:Sprite;
        public var _slotContainer:Sprite;
        public var _starContainer:Sprite;

        public var _slot0:Sprite;
        public var _slot1:Sprite;
        public var _slot2:Sprite;

        public var _balanceText:TextField;
        public var _addBalanceButton:Button;

        public var _totalBetText:TextField;

        public var _lineText:TextField;
        public var _addLineButton:Button;
        public var _minusLineButton:Button;

        public var _betText:TextField;
        public var _addBetButton:Button;
        public var _minusBetButton:Button;

        public var _spinButton:Button;

        private var _winPopup:WinPopup;

        public function HUD()
        {
            super();

            _slotMachine = new SlotMachine();

            _balance = 50;
            _bet = 1;
            _line = 3;

            Game.uiBuilder.create(JSON.parse(new EmbeddedLayouts.hud), true, this);

            _winPopup = new WinPopup();

            addChild(_root);

            initListeners();

            initSlot();

            updateText();

            positionContainer();

            Game.assetManager.addEventListener(Event.TEXTURES_RESTORED, onTextureRestore);

            _prevPositions = [0, 0, 0];
        }

        private function onTextureRestore(event:Event):void
        {
            initSlot();
        }

        public function get totalBet():int
        {
            return _bet * _line;
        }

        private function initListeners():void
        {
            _addBalanceButton.addEventListener(Event.TRIGGERED, onAddBalance);
            _addLineButton.addEventListener(Event.TRIGGERED, onAddLine);
            _minusLineButton.addEventListener(Event.TRIGGERED, onMinusLine);
            _addBetButton.addEventListener(Event.TRIGGERED, onAddBet);
            _minusBetButton.addEventListener(Event.TRIGGERED, onMinusBet);
            _spinButton.addEventListener(Event.TRIGGERED, onSpin);
        }

        private function updateText():void
        {
            _balanceText.text = _balance.toString();
            _totalBetText.text = totalBet.toString();
            _lineText.text = "line: " + _line.toString();
            _betText.text = "bet: " + _bet.toString();
        }

        private function positionContainer():void
        {
            const margin:int = 40;
            var stage:Stage = Starling.current.stage;
            _topContainer.x = stage.stageWidth - _topContainer.width - margin;
            _topContainer.y = margin;

            Utils.centerToStage(_slotContainer);
        }

        private function onAddBalance(event:Event):void
        {
            _balance += ADD_BALANCE_AMOUNT;
            updateText();
        }

        private function onAddLine(event:Event):void
        {
            if (_line < _slotMachine.numLine)
            {
                ++_line;
                updateText();
            }

            updateStars();
        }

        private function onMinusLine(event:Event):void
        {
            if (_line > 1)
            {
                --_line;
                updateText();
            }

            updateStars();
        }

        private function onAddBet(event:Event):void
        {
            _bet += ADD_BET_AMOUNT;
            updateText();
        }

        private function onMinusBet(event:Event):void
        {
            if (_bet > ADD_BET_AMOUNT)
            {
                _bet -= ADD_BET_AMOUNT;
                updateText();
            }
        }

        private function onSpin(event:Event):void
        {
            if (_spinning || _balance < totalBet)
                return;

            _balance -= totalBet;
            updateText();

            _slotMachine.spin();

            animateSpin();
        }

        private function onSpinComplete():void
        {
            var amount:int = _slotMachine.getPayment(_line);

            if (amount > 0)
            {
                var winAmount:int = _bet * amount;
                showWinPopup(winAmount);
                _balance += winAmount;
                updateText();
            }
        }

        private function initSlot():void
        {
            var image:Image;

            var slots:Array = _slotMachine.slots;
            var positions:Array = _slotMachine.positions;

            for (var i:int = 0; i < slots.length; ++i)
            {
                var slot:Array = slots[i];

                //Create the render texture for each reel
                var rt:RenderTexture = new RenderTexture(CARD_SIZE, CARD_SIZE * slot.length);

                //Draw cards into the reel
                for (var j:int = 0; j < slot.length; ++j)
                {
                    image = new Image(Game.assetManager.getTexture(slot[j]));
                    image.y = CARD_SIZE * j;
                    rt.draw(image);
                }

                var sprite:Sprite = this["_slot" + i];
                sprite.removeChildren(0, -1, true);

                //Create image with the render texture and add to the container
                var reel:Image = new Image(rt);
                reel.width = CARD_SIZE;
                reel.height = CARD_SIZE * 3;
                reel.tileGrid = new flash.geom.Rectangle(0, (1 - positions[i]) * CARD_SIZE, CARD_SIZE, CARD_SIZE * slot.length);
                sprite.addChild(reel);
            }
        }

        private function animateSpin():void
        {
            var slots:Array = _slotMachine.slots;
            var positions:Array = _slotMachine.positions;

            _spinning = true;

            var count:int = 0;

            for (var i:int = 0; i < 3; ++i)
            {
                //Calculate the distance based on previous and current positions
                var distance:int =  ((_prevPositions[i] - positions[i]) + slots[i].length) * CARD_SIZE + 2 * CARD_SIZE * slots[i].length * (i + 1);

                _prevPositions[i] = positions[i];

                var reel:Image = this["_slot" + i].getChildAt(0);

                //Tween reel.tileGrid.y by distance
                Starling.juggler.tween(reel.tileGrid, distance / SPIN_SPEED, {y:reel.tileGrid.y + distance,
                    onUpdate:function(r:Image):void
                    {
                        r.tileGrid = r.tileGrid;
                    },
                    onUpdateArgs:[reel],
                    onComplete:function():void
                    {
                        ++count;
                        if (count == 3)
                        {
                            _spinning = false;
                            onSpinComplete();
                        }
                    }
                });
            }
        }

        private function showWinPopup(amount:int):void
        {
            addChild(_winPopup);
            _winPopup.show(amount);
        }

        override public function dispose():void
        {
            Game.assetManager.removeEventListener(Event.TEXTURES_RESTORED, onTextureRestore);
            super.dispose();
        }

        private function updateStars():void
        {
            _starContainer.removeChildren(0, -1, true);

            if (_line >= 1)
            {
                updateStar(-30, 95 + 150);
                updateStar(490 + 30, 95 + 150);
            }
            if (_line >= 2)
            {
                updateStar(-30, 95);
                updateStar(490 + 30, 95);
            }
            if (_line >= 3)
            {
                updateStar(-30, 95 + 300);
                updateStar(490 + 30, 95 + 300);
            }
        }

        private function updateStar(x:int, y:int):void
        {
            var star:Image = new Image(Game.assetManager.getTexture("star"));
            star.alignPivot();
            star.x = x;
            star.y = y;
            _starContainer.addChild(star);
            Starling.current.juggler.delayCall(function():void{
                star.removeFromParent(true);
            }, 1);
        }
    }
}
