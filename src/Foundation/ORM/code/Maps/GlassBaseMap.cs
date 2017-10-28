using Glass.Mapper.Sc.Configuration;
using Glass.Mapper.Sc.Maps;
using Helix.Skeleton.Foundation.ORM.Models;

namespace Helix.Skeleton.Foundation.ORM.Maps
{
    public class GlassBaseMap : SitecoreGlassMap<IGlassBase>
    {
        public override void Configure()
        {
            Map(x =>
            {
                x.Id(y => y.Id);
                x.Info(y => y.Language).InfoType(SitecoreInfoType.Language);
                x.Info(y => y.TemplateName).InfoType(SitecoreInfoType.TemplateName);
                x.Info(y => y.TemplateId).InfoType(SitecoreInfoType.TemplateId);
                x.Info(y => y.Name).InfoType(SitecoreInfoType.Name);
                x.Info(y => y.Url).InfoType(SitecoreInfoType.Url);
                x.Info(y => y.FullPath).InfoType(SitecoreInfoType.FullPath);
            });
        }
    }
}
