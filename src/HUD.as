package
{
    import starling.core.Starling;
    import starling.display.Button;
    import starling.display.Sprite;
    import starling.display.Stage;
    import starling.events.Event;
    import starling.text.TextField;

    public class HUD extends Sprite
    {
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

        public function HUD()
        {
            Game.uiBuilder.create(JSON.parse(new EmbeddedLayouts.hud), true, this) as Sprite;
            addChild(_root);

            var stage:Stage = Starling.current.stage;

            const margin:Number = 40;
            _topContainer.x = stage.stageWidth - _topContainer.width - margin;
            _topContainer.y = margin;

            _slotContainer.x = (stage.stageWidth - _slotContainer.width) * 0.5;
            _slotContainer.y = (stage.stageHeight - _slotContainer.height) * 0.5;

            _balanceText.text = "999";
            _addBalanceButton.addEventListener(Event.TRIGGERED, onAddBalance);
        }

        private function onAddBalance(event:Event):void
        {
            trace("adding balance...");
        }
    }
}
