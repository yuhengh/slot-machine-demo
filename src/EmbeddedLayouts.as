package
{
    public class EmbeddedLayouts
    {
        [Embed(source="layouts/hello.json", mimeType="application/octet-stream")]
        public static const Hello:Class;
    }
}
