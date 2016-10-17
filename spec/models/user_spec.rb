require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do
    it 'should have no errors if field are filled correctly' do
      @user = User.create(
        first_name: 'Example first name',
        last_name: 'Example last name',
        email: 'Example@email.com',
        password: '1234',
        password_confirmation: '1234'
      )
      expect(@user.errors.size).to be 0
      expect(@user.errors.full_messages).to be_empty
    end

    it 'should require password fields when creating model' do
      @user = User.create(
        first_name: 'Example first name',
        last_name: 'Example last name',
        email: 'Example@email.com'
      )
      expect(@user.errors.size).to be 4
      expect(@user.errors.full_messages).to include('Password can\'t be blank')
      expect(@user.errors.full_messages).to include('Password digest can\'t be blank')
    end

    it 'should give an error if password does not match password confirmation' do
      @user = User.create(
        first_name: 'Example first name',
        last_name: 'Example last name',
        email: 'Example@email.com',
        password: '1234',
        password_confirmation: '12345'
      )
      expect(@user.errors.size).to be 1
      expect(@user.errors.full_messages).to include('Password confirmation doesn\'t match Password')
    end

    it 'should give an error if password confirmation is not provided' do
      @user = User.create(
        first_name: 'Example first name',
        last_name: 'Example last name',
        email: 'Example@email.com',
        password: '1234'
      )
      expect(@user.errors.size).to be 1
    end

    it 'should give an error if email is not unique' do
      @user1 = User.create(
        first_name: 'Example first name1',
        last_name: 'Example last name1',
        email: 'Example@email.com',
        password: '1234',
        password_confirmation: '1234'
      )

      @user2 = User.create(
        first_name: 'Example first name2',
        last_name: 'Example last name2',
        email: 'EXAMPLE@EMAIL.COM',
        password: '5678',
        password_confirmation: '5678'
      )
      expect(@user2.errors.size).to be 1
      expect(@user2.errors.full_messages).to include('Email has already been taken')
    end

    it 'should require an email' do
      @user = User.create(
        first_name: 'Example first name',
        last_name: 'Example last name',
        password: '1234',
        password_confirmation: '1234'
      )
      expect(@user.errors.size).to be 1
      expect(@user.errors.full_messages).to include('Email can\'t be blank')
    end

    it 'should require a first name' do
      @user = User.create(
        last_name: 'Example last name',
        email: 'Example@email.com',
        password: '1234',
        password_confirmation: '1234'
      )
      expect(@user.errors.size).to be 1
      expect(@user.errors.full_messages).to include('First name can\'t be blank')
    end

    it 'should require a last name' do
      @user = User.create(
        first_name: 'Example first name',
        email: 'Example@email.com',
        password: '1234',
        password_confirmation: '1234'
      )
      expect(@user.errors.size).to be 1
      expect(@user.errors.full_messages).to include('Last name can\'t be blank')
    end

    it 'should require password to have a minimum length of 3' do
      @user = User.create(
        first_name: 'Example first name',
        last_name: 'Example last name',
        email: 'Example@email.com',
        password: '12',
        password_confirmation: '12'
      )
      expect(@user.errors.size).to be 2
      expect(@user.errors.full_messages).to include('Password is too short (minimum is 3 characters)')
      expect(@user.errors.full_messages).to include('Password confirmation is too short (minimum is 3 characters)')
    end
  end

  describe '.authenticate_with_credentials' do
    it 'should authenticate login' do
      @user = User.create(
        first_name: 'Example first name',
        last_name: 'Example last name',
        email: 'Example@email.com',
        password: '1234',
        password_confirmation: '1234'
      )
      @user_auth = User.authenticate_with_credentials('Example@email.com', '1234')
      expect(@user_auth).to eq @user
    end

    it 'should return nil if password is incorrect' do
      @user = User.create(
        first_name: 'Example first name',
        last_name: 'Example last name',
        email: 'Example@email.com',
        password: '1234',
        password_confirmation: '1234'
      )
      @user_auth = User.authenticate_with_credentials('Example@email.com', '12345')
      expect(@user_auth).to be nil
    end

    it 'should authenticate login even with white space in front of email' do
      @user = User.create(
        first_name: 'Example first name',
        last_name: 'Example last name',
        email: 'Example@email.com',
        password: '1234',
        password_confirmation: '1234'
      )
      @user_auth = User.authenticate_with_credentials(' Example@email.com', '1234')
      expect(@user_auth).to eq @user
    end

    it 'should authenticate login even with white space after email' do
      @user = User.create(
        first_name: 'Example first name',
        last_name: 'Example last name',
        email: 'Example@email.com',
        password: '1234',
        password_confirmation: '1234'
      )
      @user_auth = User.authenticate_with_credentials(' Example@email.com', '1234')
      expect(@user_auth).to eq @user
    end

    it 'should authenticate login case insensitive' do
      @user = User.create(
        first_name: 'Example first name',
        last_name: 'Example last name',
        email: 'Example@email.com',
        password: '1234',
        password_confirmation: '1234'
      )
      @user_auth = User.authenticate_with_credentials('EXAMPLE@email.com', '1234')
      expect(@user_auth).to eq @user
    end
  end

end
