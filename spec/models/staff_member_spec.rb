require 'rails_helper'

RSpec.describe StaffMember, type: :model do
  describe "#password=" do
    it "文字列を与えると、hashed_passwordは長さ60の文字列になる" do
      member = StaffMember.new
      member.password = "baukis"
      expect(member.hashed_password).to be_kind_of(String)
      expect(member.hashed_password.size).to eq(60)
    end

    it "nilを与えると、hashed_passwordはnilになる" do
      member = StaffMember.new(hashed_password: "x")
      member.password = nil
      expect(member.hashed_password).to be_nil
    end
  end

  describe "値の正規化" do
    it "emailの空白を除去" do
      member = StaffMember.create(email: " test@example.com ")
      expect(member.email).to eq("test@example.com")
    end

    it "emailに含まれる全角英数記号を半角に変換" do
      member = StaffMember.create(email: "ｔｅｓｔ@ｅｘａｍｐｌｅ.com ")
      expect(member.email).to eq("test@example.com")
    end

    it "emailの前後の全角スペースを排除" do
      member = StaffMember.create(email: "\u{3000}test@example.com\u{3000}")
      expect(member.email).to eq("test@example.com")
    end

    it "family_name_kanaに含まれる平仮名をカタカナに変換" do
      member = StaffMember.create(family_name_kana: "てすと")
      expect(member.family_name_kana).to eq("テスト")
    end

    it "family_name_kanaに含まれる半角カナを全角カナに変換" do
      member = StaffMember.create(family_name_kana: "ﾃｽﾄ")
      expect(member.family_name_kana).to eq("テスト")
    end
  end

  describe "バリデーション" do
    it "@を2個以上含むemailは無効" do
      member = build(:staff_member, email: "test@@example.com")
      expect(member).not_to be_valid
    end

    it "アルファベット表記のfamily_nameは有効" do
      member = build(:staff_member, family_name: "Smith")
      expect(member).to be_valid
    end

    it "記号を含むfamily_nameは無効" do
      member = build(:staff_member, family_name: "Smith$")
      expect(member).not_to be_valid
    end

    it "漢字を含むfamily_name_kanaは無効" do
      member = build(:staff_member, family_name_kana: "試験")
      expect(member).not_to be_valid
    end

    it "長音符を含むfamily_name_kanaは有効" do
      member = build(:staff_member, family_name_kana: "テストー")
      expect(member).to be_valid
    end

    it "他の職員のメールアドレスと重複したemailは無効" do
      member1 = create(:staff_member)
      member2 = build(:staff_member, email: member1.email)
      expect(member2).not_to be_valid
    end
  end
end
