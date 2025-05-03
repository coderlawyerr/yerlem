class MapData {
  int? version;
  String? id;
  String? name;
  Sources? sources;
  List<Layers>? layers;
  Metadata? metadata;
  String? glyphs;
  String? sprite;
  int? bearing;
  int? pitch;
  List<int>? center;
  int? zoom;

  MapData({
    this.version,
    this.id,
    this.name,
    this.sources,
    this.layers,
    this.metadata,
    this.glyphs,
    this.sprite,
    this.bearing,
    this.pitch,
    this.center,
    this.zoom,
  });

  MapData.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    id = json['id'];
    name = json['name'];
    sources = json['sources'] != null ? Sources.fromJson(json['sources']) : null;
    if (json['layers'] != null) {
      layers = <Layers>[];
      json['layers'].forEach((v) {
        layers!.add(Layers.fromJson(v));
      });
    }
    metadata = json['metadata'] != null ? Metadata.fromJson(json['metadata']) : null;
    glyphs = json['glyphs'];
    sprite = json['sprite'];
    bearing = json['bearing'];
    pitch = json['pitch'];
    center = json['center']?.cast<int>();
    zoom = json['zoom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['version'] = version;
    data['id'] = id;
    data['name'] = name;
    if (sources != null) data['sources'] = sources!.toJson();
    if (layers != null) data['layers'] = layers!.map((v) => v.toJson()).toList();
    if (metadata != null) data['metadata'] = metadata!.toJson();
    data['glyphs'] = glyphs;
    data['sprite'] = sprite;
    data['bearing'] = bearing;
    data['pitch'] = pitch;
    data['center'] = center;
    data['zoom'] = zoom;
    return data;
  }
}

class Sources {
  Land? land;
  MaptilerAttribution? maptilerAttribution;
  Land? maptilerPlanet;

  Sources({this.land, this.maptilerAttribution, this.maptilerPlanet});

  Sources.fromJson(Map<String, dynamic> json) {
    land = json['land'] != null ? Land.fromJson(json['land']) : null;
    maptilerAttribution = json['maptiler_attribution'] != null ? MaptilerAttribution.fromJson(json['maptiler_attribution']) : null;
    maptilerPlanet = json['maptiler_planet'] != null ? Land.fromJson(json['maptiler_planet']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (land != null) data['land'] = land!.toJson();
    if (maptilerAttribution != null) data['maptiler_attribution'] = maptilerAttribution!.toJson();
    if (maptilerPlanet != null) data['maptiler_planet'] = maptilerPlanet!.toJson();
    return data;
  }
}

class Land {
  String? url;
  String? type;

  Land({this.url, this.type});

  Land.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['url'] = url;
    data['type'] = type;
    return data;
  }
}

class MaptilerAttribution {
  String? attribution;
  String? type;

  MaptilerAttribution({this.attribution, this.type});

  MaptilerAttribution.fromJson(Map<String, dynamic> json) {
    attribution = json['attribution'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['attribution'] = attribution;
    data['type'] = type;
    return data;
  }
}

class Layers {
  String? id;
  String? type;

  Layers({this.id, this.type});

  Layers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['type'] = type;
    return data;
  }
}

class Metadata {
  String? maptilerCopyright;

  Metadata({this.maptilerCopyright});

  Metadata.fromJson(Map<String, dynamic> json) {
    maptilerCopyright = json['maptiler:copyright'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['maptiler:copyright'] = maptilerCopyright;
    return data;
  }
}
