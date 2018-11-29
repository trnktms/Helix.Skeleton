using Glass.Mapper.Sc.Maps;
using [projectName].Feature.Demo.Models;
using [projectName].Foundation.ORM.Models;

namespace [projectName].Feature.Demo.Maps
{
    public class DemoMap : SitecoreGlassMap<IDemo>
    {
        public override void Configure()
        {
            Map(x =>
            {
                ImportMap<IGlassBase>();
                x.Field(y => y.Text).FieldId(SitecoreTemplates.Demo.Text.FieldId);
            });
        }
    }
}