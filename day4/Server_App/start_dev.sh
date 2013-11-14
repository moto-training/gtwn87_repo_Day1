#!/bin/sh
exec erl -pa ebin deps/*/ebin -boot start_sasl \
	-s srv_app -config priv/app