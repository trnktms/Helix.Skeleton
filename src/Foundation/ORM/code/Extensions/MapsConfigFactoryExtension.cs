using Glass.Mapper.IoC;
using Glass.Mapper.Maps;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Reflection;
using System.Text.RegularExpressions;

namespace Helix.Skeleton.Foundation.ORM.Extensions
{
    public static class MapsConfigFactoryExtension
    {
        public static void AddFluentMaps(this IConfigFactory<IGlassMap> mapsConfigFactory, params string[] assemblyFilters)
        {
            var assemblies = GetByFilter(assemblyFilters);

            AddFluentMaps(mapsConfigFactory, assemblies);
        }

        public static void AddFluentMaps(this IConfigFactory<IGlassMap> mapsConfigFactory, params Assembly[] assemblies)
        {
            var mappings = GetTypesImplementing<IGlassMap>(assemblies);

            foreach (var map in mappings)
            {
                mapsConfigFactory.Add(() => Activator.CreateInstance(map) as IGlassMap);
            }
        }

        public static Assembly[] GetByFilter(params string[] assemblyFilters)
        {
            var assemblyNames = new HashSet<string>(assemblyFilters.Where(filter => !filter.Contains('*')));
            var wildcardNames = assemblyFilters.Where(filter => filter.Contains('*')).ToArray();

            var assemblies = AppDomain.CurrentDomain.GetAssemblies().Where(assembly =>
            {
                var nameToMatch = assembly.GetName().Name;
                if (assemblyNames.Contains(nameToMatch))
                {
                    return true;
                }

                return wildcardNames.Any(wildcard => IsWildcardMatch(nameToMatch, wildcard));
            })
            .ToArray();

            return assemblies;
        }

        public static Type[] GetTypesImplementing<T>(params Assembly[] assemblies)
        {
            if (assemblies == null || assemblies.Length == 0)
            {
                return new Type[0];
            }

            var targetType = typeof(T);

            return assemblies
                .Where(assembly => !assembly.IsDynamic)
                .SelectMany(GetExportedTypes)
                .Where(type => !type.IsAbstract && !type.IsGenericTypeDefinition && targetType.IsAssignableFrom(type))
                .ToArray();
        }

        private static IEnumerable<Type> GetExportedTypes(Assembly assembly)
        {
            try
            {
                return assembly.GetExportedTypes();
            }
            catch (NotSupportedException)
            {
                // A type load exception would typically happen on an Anonymously Hosted DynamicMethods
                // Assembly and it would be safe to skip this exception.
                return Type.EmptyTypes;
            }
            catch (ReflectionTypeLoadException ex)
            {
                // Return the types that could be loaded. Types can contain null values.
                return ex.Types.Where(type => type != null);
            }
            catch (Exception ex)
            {
                // Throw a more descriptive message containing the name of the assembly.
                throw new InvalidOperationException(
                    string.Format(CultureInfo.InvariantCulture,"Unable to load types from assembly {0}. {1}", assembly.FullName, ex.Message),
                    ex);
            }
        }

        private static bool IsWildcardMatch(string input, string wildcards)
        {
            return Regex.IsMatch(input, "^" + Regex.Escape(wildcards).Replace("\\*", ".*").Replace("\\?", ".") + "$", RegexOptions.IgnoreCase);
        }
    }
}
