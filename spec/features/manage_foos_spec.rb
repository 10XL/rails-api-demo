require 'rails_helper'

RSpec.feature "ManageFoos", type: :feature, :js=>true do
  include_context "db_cleanup_each"
  FOO_FORM_XPATH = "//h3[text()='Foos']/../form"
  FOO_LIST_XPATH = "//h3[text()='Foos']/../ul"

  feature "view existing Foos" do
    let(:foos) { (1..5).map { FactoryGirl.create(:foo) }.sort_by { |v| v["name"] } }

    scenario "when no instances exist" do
      visit root_path
      within(:xpath, FOO_LIST_XPATH) do                             # waits for ul tag
        expect(page).to have_no_css("li")                           # waits for ul li tag
        expect(page).to have_css("li", count:0)                     # waits for ul li tag
        expect(all("ul li").size).to eq(0)                          # no wait
      end
    end

    scenario "when instances exist" do
      visit root_path if foos                                       # need to touch collection before hitting page
      within(:xpath, FOO_LIST_XPATH) do
        expect(page).to have_css("li:nth-child(#{foos.count})")     # waits for li(5)
        expect(page).to have_css("li", count:foos.count)            # waits for ul li tag
        expect(all("li").size).to eq(foos.count)                    # no wait
        foos.each_with_index do |foo, idx|
          expect(page).to have_css("li:nth-child(#{idx+1})", :text=>foo.name)
        end
      end
    end
  end

  feature "add new Foo" do
    scenario "has input form"
    scenario "complete form"
  end

  feature "with existing Foo" do
    scenario "can be updated"
    scenario "can be deleted"
  end
end
