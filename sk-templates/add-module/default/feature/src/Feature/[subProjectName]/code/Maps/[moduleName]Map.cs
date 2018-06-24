using Glass.Mapper.Sc.Maps;
using [projectName].Feature.[subProjectName].Models;
using [projectName].Foundation.ORM.Models;

namespace [projectName].Feature.[subProjectName].Maps
{
    public class [moduleName]Map : SitecoreGlassMap<I[moduleName]>
    {
        public override void Configure()
        {
            Map(x =>
            {
                ImportMap<IGlassBase>();
            });
        }
    }
}