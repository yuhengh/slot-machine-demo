package
{
    import starling.display.Sprite;
    import starling.utils.AssetManager;

    import starlingbuilder.engine.DefaultAssetMediator;
    import starlingbuilder.engine.IAssetMediator;
    import starlingbuilder.engine.IUIBuilder;
    import starlingbuilder.engine.UIBuilder;

    public class Game extends Sprite
    {
        public static var assetManager:AssetManager;
        private var _assetMediator:IAssetMediator;

        public static var uiBuilder:IUIBuilder;

        public function Game()
        {
            assetManager = new AssetManager();
            _assetMediator = new DefaultAssetMediator(assetManager);
            uiBuilder = new UIBuilder(_assetMediator);

            assetManager.enqueue(EmbeddedAssets);
            //assetManager.enqueue(File.applicationDirectory.resolvePath("textures"));
            assetManager.loadQueue(function(ratio:Number):void{
                if (ratio == 1)
                {
                    init();
                }
            });
        }

        private function init():void
        {
            addChild(new HUD());
        }
    }
}
