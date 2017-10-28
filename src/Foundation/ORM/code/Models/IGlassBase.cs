using Sitecore.Globalization;
using System;

namespace Helix.Skeleton.Foundation.ORM.Models
{
    public interface IGlassBase
    {
        Guid Id { get; set; }

        Language Language { get; }

        string TemplateName { get; }

        Guid TemplateId { get; set; }

        string Name { get; set; }

        string Url { get; }

        string FullPath { get; }
    }
}
