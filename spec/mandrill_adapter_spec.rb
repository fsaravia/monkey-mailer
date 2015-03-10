require_relative 'spec_helper'

describe 'Mandrill Adapter' do
  before do
    @adapter = MonkeyMailer::Adapters::MandrilAPI.new({})
  end

  it 'should parse recipients' do
    recipients = "eddie@pj.com, jeff@pj.com, mike@pj.com, stone@pj.com, matt@pj.com"

    names = "Eddie, Jeff, Mike, Stone, Matt"

    to_field = @adapter.parse_recipients(recipients, names)

    to_field.should include({ "email" => "eddie@pj.com", "name" => "Eddie", "type" => "to" })
    to_field.should include({ "email" => "jeff@pj.com", "name" => "Jeff", "type" => "to" })
    to_field.should include({ "email" => "mike@pj.com", "name" => "Mike", "type" => "to" })
    to_field.should include({ "email" => "stone@pj.com", "name" => "Stone", "type" => "to" })
    to_field.should include({ "email" => "matt@pj.com", "name" => "Matt", "type" => "to" })
  end

  it 'should not allow an empty recipients list' do
    expect {
      @adapter.parse_recipients("")
    }.to raise_error(RuntimeError, "No recipients specified")
  end

  it 'should not allow unmatched emails and names lists' do
    recipients = "eddie@pj.com,jeff@pj.com"
    names = "Eddie,Jeff,Stone"

    expect {
      @adapter.parse_recipients(recipients, names)
    }.to raise_error(RuntimeError, "Recipients and Names lists don't match")
  end
end
