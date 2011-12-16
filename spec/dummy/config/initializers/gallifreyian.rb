# encoding: utf-8
#I18n.backend = Gallifreyian::Store.backend
Gallifreyian::Store.main_language = :en
I18n.backend = I18n::Backend::Chain.new(Gallifreyian::Store.backend, I18n.backend)
