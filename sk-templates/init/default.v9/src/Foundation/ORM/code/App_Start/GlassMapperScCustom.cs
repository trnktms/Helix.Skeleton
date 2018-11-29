#region GlassMapperScCustom generated code
using Glass.Mapper.Configuration;
using Glass.Mapper.IoC;
using Glass.Mapper.Maps;
using Glass.Mapper.Sc.IoC;
using [projectName].Foundation.ORM.Extensions;
using IDependencyResolver = Glass.Mapper.Sc.IoC.IDependencyResolver;

namespace [projectName].Foundation.ORM.App_Start
{
    /// <source>
    /// https://github.com/muso31/Helixbase/blob/master/src/Foundation/ORM/code/App_Start/GlassMapperScCustom.cs
    /// </source>
    public static  class GlassMapperScCustom
    {
		public static IDependencyResolver CreateResolver(){
			var config = new Glass.Mapper.Sc.Config();

			var dependencyResolver = new DependencyResolver(config);

            // add any changes to the standard resolver here

            // dependencyResolver.Finalize();

            return dependencyResolver;
		}

		public static IConfigurationLoader[] GlassLoaders(){			
			
			/* USE THIS AREA TO ADD FLUENT CONFIGURATION LOADERS
             * 
             * If you are using Attribute Configuration or automapping/on-demand mapping you don't need to do anything!
             * 
             */

			return new IConfigurationLoader[]{};
		}
		public static void PostLoad(){
			//Remove the comments to activate CodeFist
			/* CODE FIRST START
            var dbs = Sitecore.Configuration.Factory.GetDatabases();
            foreach (var db in dbs)
            {
                var provider = db.GetDataProviders().FirstOrDefault(x => x is GlassDataProvider) as GlassDataProvider;
                if (provider != null)
                {
                    using (new SecurityDisabler())
                    {
                        provider.Initialise(db);
                    }
                }
            }
             * CODE FIRST END
             */
		}
		public static void AddMaps(IConfigFactory<IGlassMap> mapsConfigFactory)
        {
            // Add maps here
            // mapsConfigFactory.Add(() => new SeoMap());
            mapsConfigFactory.AddFluentMaps("[projectName].Foundation.*", "[projectName].Feature.*");
        }
    }
}
#endregion
