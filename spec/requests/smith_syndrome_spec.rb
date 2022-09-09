require "rails_helper"

# This spec is read-only
RSpec.describe "Smith Syndrome Risk Assessment", type: :request do
  describe "POST /smith_syndrome" do
    context "fixtures" do
      # Examples 3 and 4 are for the final criterion
      [1,2,5,6].each do |i|
        input_filename = "patient_0#{i}.json"
        output_filename = "patient_0#{i}.json"

        example "input #{input_filename} produces output #{output_filename}" do
          output = File.read(Rails.root.join('spec', 'fixtures', 'output', output_filename))
          input = JSON.parse(File.read(Rails.root.join('spec', 'fixtures', 'input', input_filename)))

          post "/smith_syndrome", params: input

          expected_json_response = JSON.parse(output)
          json_response = JSON.parse(response.body)

          # Tolerate reasons in any order
          if json_response["reasons"].present?
            expect(json_response["meetsCriteria"]).to eq(expected_json_response["meetsCriteria"])
            expect(json_response["reasons"]).to match_array(expected_json_response["reasons"])
          else
            expect(json_response).to eq(expected_json_response)
          end
        end
      end
    end
  end
end
