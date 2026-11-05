using System.Collections.Generic;

namespace Plyry.Plant3D.Core;

public sealed class MappingPackage
{
    public int SchemaVersion { get; set; }
    public MappingSource Source { get; set; } = new();
    public MappingTargetProject Target { get; set; } = new();
    public int Revision { get; set; }
    public List<PcfComponent> Components { get; set; } = new();
    public MappingSummary Report { get; set; } = new();
}

public sealed class MappingSource
{
    public string FileName { get; set; } = "";
    public string? Pipeline { get; set; }
    public string CoordinateUnits { get; set; } = "MM";
}

public sealed class MappingTargetProject
{
    public string RevitVersion { get; set; } = "";
    public string Configuration { get; set; } = "";
}

public sealed class MappingSummary
{
    public int TotalComponents { get; set; }
    public int MappedComponents { get; set; }
    public int UniqueGroups { get; set; }
}

public sealed class PcfComponent
{
    public string ComponentId { get; set; } = "";
    public string Signature { get; set; } = "";
    public string ComponentType { get; set; } = "";
    public string Skey { get; set; } = "";
    public string Specification { get; set; } = "";
    public string ItemCode { get; set; } = "";
    public string Description { get; set; } = "";
    public double? NominalSizeMm { get; set; }
    public string NominalSize { get; set; } = "";
    public int Line { get; set; }
    public List<PcfPoint> Points { get; set; } = new();
    public Dictionary<string, List<string>> Properties { get; set; } = new();
    public MappingButton Target { get; set; } = new();
}

public sealed class PcfPoint
{
    public string Kind { get; set; } = "";
    public List<double> XyzM { get; set; } = new();
}

public sealed class MappingButton
{
    public int ServiceId { get; set; }
    public int PaletteIndex { get; set; }
    public int ButtonIndex { get; set; }
    public string ButtonName { get; set; } = "";
    public string ServiceName { get; set; } = "";
    public string Code { get; set; } = "";
}

public sealed class RevitFabricationCatalog
{
    public int SchemaVersion { get; set; } = 1;
    public string RevitVersion { get; set; } = "";
    public string Configuration { get; set; } = "";
    public List<RevitFabricationButton> Buttons { get; set; } = new();
}

public sealed class RevitFabricationButton
{
    public int ServiceId { get; set; }
    public int PaletteIndex { get; set; }
    public int ButtonIndex { get; set; }
    public string Name { get; set; } = "";
    public string Code { get; set; } = "";
    public string ServiceName { get; set; } = "";
    public string PaletteName { get; set; } = "";
    public int ConditionCount { get; set; }
    public bool IsStraight { get; set; }
    public bool IsHanger { get; set; }
}
