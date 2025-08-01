require "rails_helper"

RSpec.describe GithubUser::Synchronizer do
  describe "#upsert!" do
    let(:params) do
      [
        {
          "id" => "github_user_1",
          "login" => "johndoe",
          "name" => "John Doe",
          "avatarUrl" => "https://example.com/avatar1.png",
          "__typename" => "User",
        },
        {
          "id" => "github_user_2",
          "login" => "janedoe",
          "name" => "Jane Alice Doe",
          "avatarUrl" => "https://example.com/avatar2.png",
          "__typename" => "User",
        },
      ]
    end

    it "upserts all users and returns a successful ServiceResult" do
      synchronizer = described_class.new(params)

      result = synchronizer.upsert!

      expect(result.success?).to eq(true)
      expect(GithubUser.count).to eq(2)

      user1 = GithubUser.find_by(source_user_id: "github_user_1")
      expect(user1.firstname).to eq("John")
      expect(user1.lastname).to eq("Doe")

      user2 = GithubUser.find_by(source_user_id: "github_user_2")
      expect(user2.firstname).to eq("Jane Alice")
      expect(user2.lastname).to eq("Doe")
    end
  end

  describe "#split_name" do
    it "splits full names into first and last names correctly" do
      service = described_class.new
      expect(service.send(:split_name, "Benjamin Ali Akbar")).to eq({
        first_name: "Benjamin Ali",
        last_name: "Akbar",
      })

      expect(service.send(:split_name, "John")).to eq({
        first_name: "",
        last_name: "John",
      })

      expect(service.send(:split_name, "")).to eq({
        first_name: "",
        last_name: "",
      })

      expect(service.send(:split_name, nil)).to eq({
        first_name: "",
        last_name: "",
      })
    end
  end
end
