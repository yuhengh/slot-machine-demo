package
{
    public class EmbeddedAssets
    {
        [Embed(source="../assets/textures/atlas.png")]
        public static const atlas:Class;

        [Embed(source="../assets/textures/atlas.xml", mimeType="application/octet-stream")]
        public static const atlas_xml:Class;

        public function EmbeddedAssets()
        {
        }
    }
}
