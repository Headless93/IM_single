// automatically generated by the FlatBuffers compiler, do not modify

#ifndef FLATBUFFERS_GENERATED_FBGROUPSAVECHANGERS_GROUPPACK_H_
#define FLATBUFFERS_GENERATED_FBGROUPSAVECHANGERS_GROUPPACK_H_

#include "flatbuffers.h"

#include "common_generated.h"

namespace grouppack {

struct T_GROUP_SAVE_CHANGE_RS;

struct T_GROUP_SAVE_CHANGE_RS FLATBUFFERS_FINAL_CLASS : private flatbuffers::Table {
  enum {
    VT_S_RS_HEAD = 4,
    VT_GROUP_ID = 6,
    VT_SAVE_TYPE = 8
  };
  const commonpack::S_RS_HEAD *s_rs_head() const { return GetStruct<const commonpack::S_RS_HEAD *>(VT_S_RS_HEAD); }
  uint64_t group_id() const { return GetField<uint64_t>(VT_GROUP_ID, 0); }
  int8_t save_type() const { return GetField<int8_t>(VT_SAVE_TYPE, 0); }
  bool Verify(flatbuffers::Verifier &verifier) const {
    return VerifyTableStart(verifier) &&
           VerifyField<commonpack::S_RS_HEAD>(verifier, VT_S_RS_HEAD) &&
           VerifyField<uint64_t>(verifier, VT_GROUP_ID) &&
           VerifyField<int8_t>(verifier, VT_SAVE_TYPE) &&
           verifier.EndTable();
  }
};

struct T_GROUP_SAVE_CHANGE_RSBuilder {
  flatbuffers::FlatBufferBuilder &fbb_;
  flatbuffers::uoffset_t start_;
  void add_s_rs_head(const commonpack::S_RS_HEAD *s_rs_head) { fbb_.AddStruct(T_GROUP_SAVE_CHANGE_RS::VT_S_RS_HEAD, s_rs_head); }
  void add_group_id(uint64_t group_id) { fbb_.AddElement<uint64_t>(T_GROUP_SAVE_CHANGE_RS::VT_GROUP_ID, group_id, 0); }
  void add_save_type(int8_t save_type) { fbb_.AddElement<int8_t>(T_GROUP_SAVE_CHANGE_RS::VT_SAVE_TYPE, save_type, 0); }
  T_GROUP_SAVE_CHANGE_RSBuilder(flatbuffers::FlatBufferBuilder &_fbb) : fbb_(_fbb) { start_ = fbb_.StartTable(); }
  T_GROUP_SAVE_CHANGE_RSBuilder &operator=(const T_GROUP_SAVE_CHANGE_RSBuilder &);
  flatbuffers::Offset<T_GROUP_SAVE_CHANGE_RS> Finish() {
    auto o = flatbuffers::Offset<T_GROUP_SAVE_CHANGE_RS>(fbb_.EndTable(start_, 3));
    return o;
  }
};

inline flatbuffers::Offset<T_GROUP_SAVE_CHANGE_RS> CreateT_GROUP_SAVE_CHANGE_RS(flatbuffers::FlatBufferBuilder &_fbb,
    const commonpack::S_RS_HEAD *s_rs_head = 0,
    uint64_t group_id = 0,
    int8_t save_type = 0) {
  T_GROUP_SAVE_CHANGE_RSBuilder builder_(_fbb);
  builder_.add_group_id(group_id);
  builder_.add_s_rs_head(s_rs_head);
  builder_.add_save_type(save_type);
  return builder_.Finish();
}

inline const grouppack::T_GROUP_SAVE_CHANGE_RS *GetT_GROUP_SAVE_CHANGE_RS(const void *buf) {
  return flatbuffers::GetRoot<grouppack::T_GROUP_SAVE_CHANGE_RS>(buf);
}

inline bool VerifyT_GROUP_SAVE_CHANGE_RSBuffer(flatbuffers::Verifier &verifier) {
  return verifier.VerifyBuffer<grouppack::T_GROUP_SAVE_CHANGE_RS>(nullptr);
}

inline void FinishT_GROUP_SAVE_CHANGE_RSBuffer(flatbuffers::FlatBufferBuilder &fbb, flatbuffers::Offset<grouppack::T_GROUP_SAVE_CHANGE_RS> root) {
  fbb.Finish(root);
}

}  // namespace grouppack

#endif  // FLATBUFFERS_GENERATED_FBGROUPSAVECHANGERS_GROUPPACK_H_