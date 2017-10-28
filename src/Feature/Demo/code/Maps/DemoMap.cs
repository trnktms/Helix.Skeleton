using Glass.Mapper.Sc.Maps;
using Helix.Skeleton.Feature.Demo.Models;
using Helix.Skeleton.Foundation.ORM.Models;

namespace Helix.Skeleton.Feature.Demo.Maps
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
