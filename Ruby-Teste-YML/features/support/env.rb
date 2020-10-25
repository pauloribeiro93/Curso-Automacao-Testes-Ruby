require 'capybara/cucumber'
require 'selenium-webdriver'


BROWSER = ENV['BROWSER']
AMBIENTE = ENV['AMBIENTE']

CONFIG = YAML.load_file(File.dirname(__FILE__) + "/ambientes/#{AMBIENTE}.yml")

#Configuração realizada para rodar em diversos browsers
Capybara.register_driver :selenium do |app| #Sobrescrever o driver selenium
if BROWSER.eql?('chrome')
    Capybara::Selenium::Driver.new(app, :browser => :chrome)
elsif BROWSER.eql?('chrome_headless')
    Capybara::Selenium::Driver.new(app, :browser => :chrome, 
    desired_capabilities: Selenium::WebDriver::Remote::Capabilities.chrome(
        'chromeOptions' => {'args' => ['--headless', 'disable-gpu']}
    )
    )
elsif BROWSER.eql?('firefox')
    Capybara::Selenium::Driver.new(app, :browser => :firefox, :marionette=>true)
elsif BROWSER.eql?('firefox_headless')
    browser_options = Selenium::WebDriver::Firefox::Options.new(args: ['--headless'])
    Capybara::Selenium::Driver.new(app, :browser => :firefox, options: browser_options)
# elsif BROWSER.eql?('edge')
#     Capybara::Selenium::Driver.new(app, :browser => :edge)
# elsif BROWSER.eql?('safari')
#     Capybara::Selenium::Driver.new(app, :browser => :safari)
# elsif BROWSER.eql?('poltergeist')
#     options = {js_errors: false}
#     Capybara::Poltergeist::Driver.new(app, options)
end
end


Capybara.configure do |config|
    #Drivers padrão do cucumber
    #selenium - roda o firefox
    #selenium_chrome_headless - roda o chrome sem abrir o navegador
    #selenium_chrome - roda o chrome
    config.default_driver = :selenium
    config.app_host = CONFIG['url_padrao']
    config.default_max_wait_time = 5
end