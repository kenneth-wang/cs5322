ALTER TABLE SYSTEM.CUSTOMER MODIFY (AGENT_ID  DEFAULT SYS_CONTEXT('agent_ctx', 'agent_id'));