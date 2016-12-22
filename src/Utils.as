package
{
    import starling.core.Starling;
    import starling.display.DisplayObject;
    import starling.display.Stage;

    public class Utils
    {
        public static function centerToStage(obj:DisplayObject):void
        {
            var stage:Stage = Starling.current.stage;
            obj.x = (stage.stageWidth - obj.width) * 0.5;
            obj.y = (stage.stageHeight - obj.height) * 0.5;
        }
    }
}
