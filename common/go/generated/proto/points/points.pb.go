// Code generated by protoc-gen-go. DO NOT EDIT.
// versions:
// 	protoc-gen-go v1.28.1
// 	protoc        v4.25.3
// source: points/points.proto

package points

import (
	__ "./"
	protoreflect "google.golang.org/protobuf/reflect/protoreflect"
	protoimpl "google.golang.org/protobuf/runtime/protoimpl"
	reflect "reflect"
	sync "sync"
)

const (
	// Verify that this generated code is sufficiently up-to-date.
	_ = protoimpl.EnforceVersion(20 - protoimpl.MinVersion)
	// Verify that runtime/protoimpl is sufficiently up-to-date.
	_ = protoimpl.EnforceVersion(protoimpl.MaxVersion - 20)
)

type PointRecord struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields

	Time       *__.Timestamp `protobuf:"bytes,1,opt,name=time,proto3" json:"time,omitempty"`
	Latitude   float64       `protobuf:"fixed64,11,opt,name=latitude,proto3" json:"latitude,omitempty"`
	Longitude  float64       `protobuf:"fixed64,12,opt,name=longitude,proto3" json:"longitude,omitempty"`
	Prediction float32       `protobuf:"fixed32,21,opt,name=prediction,proto3" json:"prediction,omitempty"`
}

func (x *PointRecord) Reset() {
	*x = PointRecord{}
	if protoimpl.UnsafeEnabled {
		mi := &file_points_points_proto_msgTypes[0]
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		ms.StoreMessageInfo(mi)
	}
}

func (x *PointRecord) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*PointRecord) ProtoMessage() {}

func (x *PointRecord) ProtoReflect() protoreflect.Message {
	mi := &file_points_points_proto_msgTypes[0]
	if protoimpl.UnsafeEnabled && x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use PointRecord.ProtoReflect.Descriptor instead.
func (*PointRecord) Descriptor() ([]byte, []int) {
	return file_points_points_proto_rawDescGZIP(), []int{0}
}

func (x *PointRecord) GetTime() *__.Timestamp {
	if x != nil {
		return x.Time
	}
	return nil
}

func (x *PointRecord) GetLatitude() float64 {
	if x != nil {
		return x.Latitude
	}
	return 0
}

func (x *PointRecord) GetLongitude() float64 {
	if x != nil {
		return x.Longitude
	}
	return 0
}

func (x *PointRecord) GetPrediction() float32 {
	if x != nil {
		return x.Prediction
	}
	return 0
}

type Points struct {
	state         protoimpl.MessageState
	sizeCache     protoimpl.SizeCache
	unknownFields protoimpl.UnknownFields

	PointRecords []*PointRecord `protobuf:"bytes,1,rep,name=point_records,json=pointRecords,proto3" json:"point_records,omitempty"`
}

func (x *Points) Reset() {
	*x = Points{}
	if protoimpl.UnsafeEnabled {
		mi := &file_points_points_proto_msgTypes[1]
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		ms.StoreMessageInfo(mi)
	}
}

func (x *Points) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*Points) ProtoMessage() {}

func (x *Points) ProtoReflect() protoreflect.Message {
	mi := &file_points_points_proto_msgTypes[1]
	if protoimpl.UnsafeEnabled && x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use Points.ProtoReflect.Descriptor instead.
func (*Points) Descriptor() ([]byte, []int) {
	return file_points_points_proto_rawDescGZIP(), []int{1}
}

func (x *Points) GetPointRecords() []*PointRecord {
	if x != nil {
		return x.PointRecords
	}
	return nil
}

var File_points_points_proto protoreflect.FileDescriptor

var file_points_points_proto_rawDesc = []byte{
	0x0a, 0x13, 0x70, 0x6f, 0x69, 0x6e, 0x74, 0x73, 0x2f, 0x70, 0x6f, 0x69, 0x6e, 0x74, 0x73, 0x2e,
	0x70, 0x72, 0x6f, 0x74, 0x6f, 0x12, 0x06, 0x70, 0x6f, 0x69, 0x6e, 0x74, 0x73, 0x1a, 0x0a, 0x75,
	0x74, 0x69, 0x6c, 0x2e, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x22, 0x87, 0x01, 0x0a, 0x0b, 0x50, 0x6f,
	0x69, 0x6e, 0x74, 0x52, 0x65, 0x63, 0x6f, 0x72, 0x64, 0x12, 0x1e, 0x0a, 0x04, 0x74, 0x69, 0x6d,
	0x65, 0x18, 0x01, 0x20, 0x01, 0x28, 0x0b, 0x32, 0x0a, 0x2e, 0x54, 0x69, 0x6d, 0x65, 0x73, 0x74,
	0x61, 0x6d, 0x70, 0x52, 0x04, 0x74, 0x69, 0x6d, 0x65, 0x12, 0x1a, 0x0a, 0x08, 0x6c, 0x61, 0x74,
	0x69, 0x74, 0x75, 0x64, 0x65, 0x18, 0x0b, 0x20, 0x01, 0x28, 0x01, 0x52, 0x08, 0x6c, 0x61, 0x74,
	0x69, 0x74, 0x75, 0x64, 0x65, 0x12, 0x1c, 0x0a, 0x09, 0x6c, 0x6f, 0x6e, 0x67, 0x69, 0x74, 0x75,
	0x64, 0x65, 0x18, 0x0c, 0x20, 0x01, 0x28, 0x01, 0x52, 0x09, 0x6c, 0x6f, 0x6e, 0x67, 0x69, 0x74,
	0x75, 0x64, 0x65, 0x12, 0x1e, 0x0a, 0x0a, 0x70, 0x72, 0x65, 0x64, 0x69, 0x63, 0x74, 0x69, 0x6f,
	0x6e, 0x18, 0x15, 0x20, 0x01, 0x28, 0x02, 0x52, 0x0a, 0x70, 0x72, 0x65, 0x64, 0x69, 0x63, 0x74,
	0x69, 0x6f, 0x6e, 0x22, 0x42, 0x0a, 0x06, 0x50, 0x6f, 0x69, 0x6e, 0x74, 0x73, 0x12, 0x38, 0x0a,
	0x0d, 0x70, 0x6f, 0x69, 0x6e, 0x74, 0x5f, 0x72, 0x65, 0x63, 0x6f, 0x72, 0x64, 0x73, 0x18, 0x01,
	0x20, 0x03, 0x28, 0x0b, 0x32, 0x13, 0x2e, 0x70, 0x6f, 0x69, 0x6e, 0x74, 0x73, 0x2e, 0x50, 0x6f,
	0x69, 0x6e, 0x74, 0x52, 0x65, 0x63, 0x6f, 0x72, 0x64, 0x52, 0x0c, 0x70, 0x6f, 0x69, 0x6e, 0x74,
	0x52, 0x65, 0x63, 0x6f, 0x72, 0x64, 0x73, 0x42, 0x0a, 0x5a, 0x08, 0x2e, 0x2f, 0x70, 0x6f, 0x69,
	0x6e, 0x74, 0x73, 0x62, 0x06, 0x70, 0x72, 0x6f, 0x74, 0x6f, 0x33,
}

var (
	file_points_points_proto_rawDescOnce sync.Once
	file_points_points_proto_rawDescData = file_points_points_proto_rawDesc
)

func file_points_points_proto_rawDescGZIP() []byte {
	file_points_points_proto_rawDescOnce.Do(func() {
		file_points_points_proto_rawDescData = protoimpl.X.CompressGZIP(file_points_points_proto_rawDescData)
	})
	return file_points_points_proto_rawDescData
}

var file_points_points_proto_msgTypes = make([]protoimpl.MessageInfo, 2)
var file_points_points_proto_goTypes = []interface{}{
	(*PointRecord)(nil),  // 0: points.PointRecord
	(*Points)(nil),       // 1: points.Points
	(*__.Timestamp)(nil), // 2: Timestamp
}
var file_points_points_proto_depIdxs = []int32{
	2, // 0: points.PointRecord.time:type_name -> Timestamp
	0, // 1: points.Points.point_records:type_name -> points.PointRecord
	2, // [2:2] is the sub-list for method output_type
	2, // [2:2] is the sub-list for method input_type
	2, // [2:2] is the sub-list for extension type_name
	2, // [2:2] is the sub-list for extension extendee
	0, // [0:2] is the sub-list for field type_name
}

func init() { file_points_points_proto_init() }
func file_points_points_proto_init() {
	if File_points_points_proto != nil {
		return
	}
	if !protoimpl.UnsafeEnabled {
		file_points_points_proto_msgTypes[0].Exporter = func(v interface{}, i int) interface{} {
			switch v := v.(*PointRecord); i {
			case 0:
				return &v.state
			case 1:
				return &v.sizeCache
			case 2:
				return &v.unknownFields
			default:
				return nil
			}
		}
		file_points_points_proto_msgTypes[1].Exporter = func(v interface{}, i int) interface{} {
			switch v := v.(*Points); i {
			case 0:
				return &v.state
			case 1:
				return &v.sizeCache
			case 2:
				return &v.unknownFields
			default:
				return nil
			}
		}
	}
	type x struct{}
	out := protoimpl.TypeBuilder{
		File: protoimpl.DescBuilder{
			GoPackagePath: reflect.TypeOf(x{}).PkgPath(),
			RawDescriptor: file_points_points_proto_rawDesc,
			NumEnums:      0,
			NumMessages:   2,
			NumExtensions: 0,
			NumServices:   0,
		},
		GoTypes:           file_points_points_proto_goTypes,
		DependencyIndexes: file_points_points_proto_depIdxs,
		MessageInfos:      file_points_points_proto_msgTypes,
	}.Build()
	File_points_points_proto = out.File
	file_points_points_proto_rawDesc = nil
	file_points_points_proto_goTypes = nil
	file_points_points_proto_depIdxs = nil
}
