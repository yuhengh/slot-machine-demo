package
{
    public class EmbeddedLayouts
    {
        [Embed(source="layouts/win_popup.json", mimeType="application/octet-stream")]
        public static const win_popup:Class;

        [Embed(source="layouts/hud.json", mimeType="application/octet-stream")]
        public static const hud:Class;
    }
}
