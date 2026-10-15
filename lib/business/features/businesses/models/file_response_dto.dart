class FileResponseDto {
  final int? id;
  final String? key;
  final String? name;
  final String? extension;
  final double? size;
  final String? blurHash;
  final String? path;
  final String? url;
  final String? contentType;
  final String? bucket;

  FileResponseDto({
    this.id,
    this.key,
    this.name,
    this.extension,
    this.size,
    this.blurHash,
    this.path,
    this.url,
    this.contentType,
    this.bucket,
  });

  factory FileResponseDto.fromJson(Map<String, dynamic> json) {
    return FileResponseDto(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      key: json['key'] as String?,
      name: json['name'] as String?,
      extension: json['extension'] as String?,
      size: json['size'] != null ? (json['size'] as num).toDouble() : null,
      blurHash: json['blurHash'] as String?,
      path: json['path'] as String?,
      url: json['url'] as String?,
      contentType: json['contentType'] as String?,
      bucket: json['bucket'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'key': key,
      'name': name,
      'extension': extension,
      'size': size,
      'blurHash': blurHash,
      'path': path,
      'url': url,
      'contentType': contentType,
      'bucket': bucket,
    };
  }
}

