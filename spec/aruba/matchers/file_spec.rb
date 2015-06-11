require 'spec_helper'

RSpec.describe 'File Matchers' do
  include_context 'uses aruba API'
  include_context 'needs to expand paths'

  describe 'to_be_existing_file' do
    let(:name) { @file_name }

    context 'when file exists' do
      before(:each) { create_test_files(name) }

      it { expect(name).to be_existing_file }
    end

    context 'when file does not exist' do
      it { expect(name).not_to be_existing_file }
    end
  end

  describe 'to_be_existing_files' do
    let(:name) { %w(file1.txt file2.txt) }

    context 'when files exists' do
      before(:each) { create_test_files(name) }

      context 'when list of files is given' do
        it { expect(name).to be_existing_files }
      end

      context 'when no list of files is given' do
        let(:name) { 'file1.txt' }
        it { expect(name).not_to be_existing_files }
      end
    end

    context 'when file does not exist' do
      it { expect(name).not_to be_existing_files }
    end
  end

  describe 'to_have_file_content' do
    context 'when file exists' do
      before :each do
        File.write(@file_path, 'aba')
      end

      context 'and file content is exactly equal string ' do
        it { expect(@file_name).to have_file_content('aba') }
      end

      context 'and file content contains string' do
        it { expect(@file_name).to have_file_content(/b/) }
      end

      context 'and file content is not exactly equal string' do
        it { expect(@file_name).not_to have_file_content('c') }
      end

      context 'and file content not contains string' do
        it { expect(@file_name).not_to have_file_content(/c/) }
      end

      context 'when other matchers is given which matches a string start with "a"' do
        it { expect(@file_name).to have_file_content(a_string_starting_with('a')) }
      end
    end

    context 'when file does not exist' do
      it { expect(@file_name).not_to have_file_content('a') }
    end

    describe "description" do
      context "when string" do
        it { expect(have_file_content("a").description).to eq('have file content: "a"') }
      end

      context "when regexp" do
        it { expect(have_file_content(/a/).description).to eq('have file content: /a/') }
      end

      context "when matcher" do
        it { expect(have_file_content(a_string_starting_with "a").description).to eq('have file content: a string starting with "a"') }
      end
    end

    describe 'failure messages' do
      def fail_with(message)
        raise_error(RSpec::Expectations::ExpectationNotMetError, message)
      end

      example 'for a string' do
        expect do
          expect(@file_name).to have_file_content("z")
        end.to fail_with('expected "test.txt" to have file content: "z"')
      end

      example 'for a string' do
        expect do
          expect(@file_name).to have_file_content(/z/)
        end.to fail_with('expected "test.txt" to have file content: /z/')
      end

      example 'for a matcher' do
        expect do
          expect(@file_name).to have_file_content(a_string_starting_with "z")
        end.to fail_with('expected "test.txt" to have file content: a string starting with "z"')
      end
    end
  end

  describe 'to_have_file_size' do
    context 'when file exists' do
      before :each do
        File.write(@file_path, '')
      end

      context 'and file size is equal' do
        it { expect(@file_name).to have_file_size(0) }
      end

      context 'and file size is not equal' do
        it { expect(@file_name).not_to have_file_size(1) }
      end
    end

    context 'when file does not exist' do
      it { expect(@file_name).not_to have_file_size(0) }
    end
  end
end
