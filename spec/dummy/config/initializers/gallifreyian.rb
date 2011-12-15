# encoding: utf-8
#I18n.backend = Gallifreyian::Store.backend
I18n.backend = I18n::Backend::Chain.new(Gallifreyian::Store.backend, I18n.backend)
