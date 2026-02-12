class ItemsModel {

  String? id,
    title,
    description,
    image,
    link,
    background,
    codePoint,
    fontFamily,
    fontPackage,
    color,
    iconBackground,
    direction;

  ItemsModel({
    this.id,
    this.title,
    this.description,
    this.image,
    this.link,
    this.background,
    this.codePoint,
    this.fontFamily,
    this.fontPackage,
    this.color,
    this.iconBackground,
    this.direction,
  });

  
  // @override
  // String toString() => toMap().toJson();

  toMap() {

    Map newMap = {};

    Map iconMap = {};

    if(title != null && title != '') {
      newMap.addEntries({'title': title }.entries);
    }

    if(description != null && description != '') {
      newMap.addEntries({'description': description }.entries);
    }

    if(image != null && image != '') {
      newMap.addEntries({'image': image }.entries);
    }

    if(background != null && background != '') {
      newMap.addEntries({'background': background }.entries);
    }

    if(link != null && link != '') {
      newMap.addEntries({'link': link }.entries);
    }

    if(codePoint != null && codePoint != '') {
      iconMap.addEntries({'code_point': codePoint }.entries);
    }

    if(fontFamily != null && fontFamily != '') {
      iconMap.addEntries({'font_family': fontFamily }.entries);
    }

    if(fontPackage != null && fontPackage != '') {
      iconMap.addEntries({'font_package': fontPackage }.entries);
    }

    if(color != null && color != '') {
      iconMap.addEntries({'color': color }.entries);
    }

    if(direction != null && direction != '') {
      iconMap.addEntries({'direction': direction }.entries);
    }
    
    if(iconBackground != null && iconBackground != '') {
      iconMap.addEntries({'background': iconBackground }.entries);
    }

    if(iconMap.isNotEmpty) {
      newMap.addEntries({'icon': iconMap }.entries);
    }
    
    return newMap;
  }

}


